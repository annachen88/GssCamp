
var bookDataFromLocalStorage = [];

$(function(){
    loadBookData();
    var data = [
        {text:"資料庫",value:"image/database.jpg"},
        {text:"網際網路",value:"image/internet.jpg"},
        {text:"應用系統整合",value:"image/system.jpg"},
        {text:"家庭保健",value:"image/home.jpg"},
        {text:"語言",value:"image/language.jpg"},
        {text:"管理",value:"image/management.jpg"},
        {text:"行銷",value:"image/marketing.jpg"}
        
    ]
    $("#book_category").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: data,
        index: 0,
        change: onChange
    });
    $("#bought_datepicker").kendoDatePicker();
    $("#book_grid").kendoGrid({
        dataSource: {
            data: bookDataFromLocalStorage,
            schema: {
                model: {
                    fields: {
                        BookId: {type:"int"},
                        BookName: { type: "string" },
                        BookCategory: { type: "string" },
                        BookAuthor: { type: "string" },
                        BookPublisher:{type:"string"},
                        BookBoughtDate: { type: "string" }
                    }
                }
            },
            pageSize: 20,
            filterable: true,
        },
        toolbar: kendo.template("<div class='book-grid-toolbar'><input class='book-grid-search' placeholder='我想要找......' type='text'></input></div>"),
        height: 550,
        sortable: true,
        pageable: {
            input: true,
            numeric: false
        },
        columns: [
            { field: "BookId", title: "書籍編號",width:"10%"},
            { field: "BookName", title: "書籍名稱", width: "50%" },
            { field: "BookCategory", title: "書籍種類", width: "10%" },
            { field: "BookAuthor", title: "作者", width: "15%" },
            { field: "BookPublisher", title: "出版社", width: "15%" },
            { field: "BookBoughtDate", title: "購買日期", width: "15%" },
            { command: { text: "刪除", click: deleteBook }, title: " ", width: "120px" }
        ]
    });

    $("#window").kendoWindow({
        width: "500px",
        title: "新增書籤",
        actions: ["Pin",
        "Minimize",
        "Maximize",
        "Close"]
     });
    $("#open").click(function () {
        $("#window").data("kendoWindow").center().open();
    });

    $(".book-grid-search").keyup(function(){
        $("#book_grid").data("kendoGrid").dataSource.filter({
        logic: "or",
        filters: [
            { field: "BookName", 
              operator: "contains", 
              value:$(".book-grid-search").val()
            }
        ]});
    });
    
    $("#insert").click(function () {
        addBook();
    });
})


function loadBookData(){
    bookDataFromLocalStorage = JSON.parse(localStorage.getItem("bookData"));
    if(bookDataFromLocalStorage == null){
        bookDataFromLocalStorage = bookData;
        localStorage.setItem("bookData",JSON.stringify(bookDataFromLocalStorage));
    }
}

function onChange(){
    $(".book-image").attr("src",$("#book_category").data("kendoDropDownList").value());
}
  
function deleteBook(e){
   var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
   for (i = 0; i < bookDataFromLocalStorage.length; i++){
      if(bookDataFromLocalStorage[i].BookId == dataItem.BookId){
       bookDataFromLocalStorage.splice(i,1);
       break;
      }
  } 
  localStorage.setItem("bookData",JSON.stringify(bookDataFromLocalStorage));
  $("#book_grid").data("kendoGrid").dataSource.data(bookDataFromLocalStorage);
}

function addBook() {
     const add ={
        "BookId":bookDataFromLocalStorage[bookDataFromLocalStorage.length-1].BookId+1,
        "BookCategory":$("#book_category").data("kendoDropDownList").text(),
        "BookName":$("#book_name").val(),
        "BookAuthor":$("#book_author").val(),
        "BookPublisher":$("#book_publisher").val(),
        "BookBoughtDate":kendo.toString($("#bought_datepicker").data("kendoDatePicker").value(),"yyyy-MM-dd")
     }
     bookDataFromLocalStorage.push(add);
     localStorage.setItem("bookData",JSON.stringify(bookDataFromLocalStorage));
     $("#book_grid").data("kendoGrid").dataSource.data(bookDataFromLocalStorage);
     $("#book_name").val("");
     $("#book_author").val("");
     $("#book_publisher").val("");
    

    
}

