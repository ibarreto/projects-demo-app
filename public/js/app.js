$(document).ready(function() {
  $('#createProjectModalSubmitButton').on('click', function(e) {
    e.preventDefault();
    var projectName = $('#project_name').val();
    var projectDescription = $('#project_description').val();
    var projectData = {
      "project_name": projectName,
      "project_description": projectDescription
    };

    $.ajax({
      type: "POST",
      url: "/projects",
      data: projectData,
      success: function(data) {
        project = JSON.parse(data)

        var cardHtml = `
        <div class="col-sm-6">
          <div class="card mt-3">
            <div class="card-body">
              <h4 class="card-title">`+project['name']+`</h4>
              <p class="card-text">`+project['description']+`</p>
              <a href="/projects/`+project['name']+`" class="btn btn-primary">More details</a>
            </div>
          </div>
        </div>
        `
        $('#projects').append(cardHtml);
        $('#createProjectModal').modal('hide');
        $('#project_name').val('');
        $('#project_description').val('');
      },
      error: function() {
        alert('An error ocurred!');
      }
    });
  });
});
