// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import 'phoenix_html';

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import $ from 'jquery';

function updateButtons() {
  $('.manage-button').each((_, button) => {
    let user_id = $(button).data('user-id');
    let manage = $(button).data('manage');

    if (manage != '') {
      $(button).text('Unmanage');
    } else {
      $(button).text('Manage');
    }
  });
}

function setButton(user_id, value) {
  $('.manage-button').each((_, button) => {
    if (user_id == $(button).data('user-id')) {
      $(button).data('manage', value);
    }
  });

  updateButtons();
}

function manage(user_id) {
  let text = JSON.stringify({
    manage: {
      underling_id: current_user_id,
      manager_id: user_id
    }
  });

  $.ajax(manage_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (res) => {
      setButton(user_id, res.data.id);
    }
  });
}

function unmanage(user_id, manage_id) {
  $.ajax(manage_path + "/" + manage_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => {
      setButton(user_id, "");
    }
  });
}

function manageClick(ev) {
  let button = $(ev.target);
  let manage_id = button.data('manage');
  let user_id = button.data('user-id');

  if (manage_id != '') {
    unmanage(user_id, manage_id);
  } else {
    manage(user_id);
  }
}

function initManage() {
  let manageButton = $('.manage-button');

  if (!manageButton) {
    return;
  }

  manageButton.click(manageClick);
  updateButtons();
}

function startTime(taskId, time) {
  let text = JSON.stringify({
    time_block: {
      start: time,
      end: null,
      task_id: taskId
    }
  });

  $.ajax(time_block_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (res) => {
      console.log(res);
    },
    error: (res) => {
      console.error(res);
    }
  });
}

function endTime(taskId, time) {
  let text = JSON.stringify({
    time_block: {
      start_time: "",
      end: time,
      task_id: taskId
    }
  });

  $.ajax(time_block_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (res) => {
      console.log(res);
    },
    error: (res) => {
      console.error(res);
    }
  });
}

function timeClick(ev) {
  let button = $(ev.target);
  let timeType = button.data('time-type');
  let taskId = button.data('task-id');
  let time = button.data('time');

  if (timeType === 'Start') {
    startTime(taskId, time);
  } else {
    endTime(taskId, time);
  }
}

function initTime() {
  let timeButton = $('.time-button');

  if (!timeButton) {
    return;
  }

  timeButton.click(timeClick);
}

$(initManage);
$(initTime);
