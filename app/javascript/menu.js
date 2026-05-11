// 初始化ECharts图表
document.addEventListener('turbo:load', function() {
  // 处理二级菜单点击事件
  const navGroups = document.querySelectorAll('.nav-group');
  navGroups.forEach(group => {
    const navLink = group.querySelector('.nav-link');
    navLink.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      // 关闭其他打开的菜单
      navGroups.forEach(otherGroup => {
        if (otherGroup !== group) {
          otherGroup.classList.remove('active');
        }
      });
      
      // 切换当前菜单状态
      group.classList.toggle('active');
    });
    const subLinks = group.querySelectorAll('.submenu-link');
    subLinks.forEach(subLink => {
      subLink.addEventListener('click', (e) => {
        //e.preventDefault();
        e.stopPropagation();
        subLinks.forEach(otherLink => {
        if (otherLink !== subLink) {
            otherLink.classList.remove('active');
            otherLink.parentNode.previousElementSibling.classList.remove('active');
            otherLink.parentNode.parentNode.classList.remove('active');
          }
        });
        // 切换当前菜单状态
        subLink.classList.add('active');
        subLink.parentNode.previousElementSibling.classList.add('active');
        group.classList.add('active');
      });
      const currentPath = window.location.pathname;
      const itemPath = subLink.getAttribute('href');
      if (currentPath===itemPath) {
        subLinks.forEach(otherLink => {
        if (otherLink !== subLink) {
            otherLink.classList.remove('active');
            otherLink.parentNode.previousElementSibling.classList.remove('active');
            otherLink.parentNode.parentNode.classList.remove('active');
          }
        });
        // 切换当前菜单状态
        subLink.classList.add('active');
        subLink.parentNode.previousElementSibling.classList.add('active');
        group.classList.add('active');
      }

    });

  });
  // 用户头像下拉菜单交互
  const userAvatar = document.getElementById('userAvatarDropdown');
  const dropdownMenu = document.getElementById('userDropdownMenu');
  
  // 添加鼠标悬停效果
  userAvatar.addEventListener('mouseenter', () => {
    userAvatar.style.transform = 'scale(1.1)';
    userAvatar.style.boxShadow = '0 0 0 2px rgba(109, 139, 224, 0.3)';
  });
  
  userAvatar.addEventListener('mouseleave', () => {
    userAvatar.style.transform = 'scale(1)';
    userAvatar.style.boxShadow = 'none';
  });
  
  userAvatar.addEventListener('click', (e) => {
    e.stopPropagation();
    dropdownMenu.classList.toggle('show');
  });
  
  // 点击页面其他区域关闭下拉菜单
  document.addEventListener('click', () => {
    dropdownMenu.classList.remove('show');
  });
    
  $('.datepicker').datepicker({
    format: 'yyyy/mm/dd',
    startDate: '+1d',
    autoclose: true
  });

  flatpickr(".flatpickr-datetime", {
    enableTime: true,        // 启用时间选择
    dateFormat: "Y/m/d H:i", // 设置所需的日期时间格式
    time_24hr: true,
    minTime: "09:00",
    maxTime: "18:00",
    minDate: "today"
  });
});