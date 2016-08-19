DQTagsView
================

Usage

Initialize an instance with the [[DQTagsView alloc] initWithFrame: andTitle: andData: andCanDelete:] method, passing it a frame, title, array and boolean for delete function.

@protocol DQTagsViewDelegate <NSObject>

-(void)selectTag:(UIButton *)tagBtn;

-(void)deleteView:(UIButton *)deleteBtn;

Follow the delegate,

[selectTag:] method will let you to implement method for buttons on the view as tags.

[deleteView:] method will let you to implement method for the delete button if you want to let users to clear the tags view.

