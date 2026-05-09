// 初始化ECharts图表
document.addEventListener('DOMContentLoaded', function() {
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
    // 订单状态分布图表
  /*
    const orderStatusChart = echarts.init(document.getElementById('orderStatusChart'));
    const orderStatusOption = {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
            orient: 'vertical',
            right: 10,
            top: 'center',
            data: ['Pending', 'Processing', 'In Transit', 'Completed', 'Cancelled']
        },
        series: [
            {
                name: 'Order Status',
                type: 'pie',
                radius: ['40%', '70%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false,
                    position: 'center'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: '18',
                        fontWeight: 'bold'
                    }
                },
                labelLine: {
                    show: false
                },
                data: [
                    { value: 15, name: 'Pending' },
                    { value: 8, name: 'Processing' },
                    { value: 12, name: 'In Transit' },
                    { value: 32, name: 'Completed' },
                    { value: 3, name: 'Cancelled' }
                ]
            }
        ]
    };
    orderStatusChart.setOption(orderStatusOption);

    // 月度订单趋势图表
    const orderTrendChart = echarts.init(document.getElementById('orderTrendChart'));
    const orderTrendOption = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            data: ['Order Count', 'Order Amount (10k)']
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul']
        },
        yAxis: [{
            type: 'value',
            name: 'Order Count'
        }, {
            type: 'value',
            name: 'Order Amount',
            axisLabel: {
                formatter: '{value}0k'
            }
        }],
        series: [
            {
                name: 'Order Count',
                type: 'line',
                smooth: true,
                lineStyle: {
                    width: 3
                },
                data: [45, 52, 48, 65, 72, 80, 76]
            },
            {
                name: 'Order Amount (10k)',
                type: 'line',
                yAxisIndex: 1,
                smooth: true,
                lineStyle: {
                    width: 3
                },
                data: [3.2, 3.8, 3.5, 4.6, 5.2, 5.8, 5.5]
            }
        ]
    };
    orderTrendChart.setOption(orderTrendOption);

    // 窗口调整时重新渲染图表
    window.addEventListener('resize', function() {
        orderStatusChart.resize();
        orderTrendChart.resize();
    });
*/
    // 订单表单交互
    //const orderForm = document.getElementById('orderForm');
    //const newOrderBtn = document.getElementById('newOrderBtn');
    //const closeForm = document.getElementById('closeForm');
    //const cancelOrder = document.getElementById('cancelOrder');
    /*
    newOrderBtn.addEventListener('click', () => {
        orderForm.style.display = 'block';
        window.scrollTo({ top: orderForm.offsetTop - 20, behavior: 'smooth' });
    });
    
    closeForm.addEventListener('click', () => {
        orderForm.style.display = 'none';
    });
    
    cancelOrder.addEventListener('click', () => {
        orderForm.style.display = 'none';
        document.getElementById('newOrderForm').reset();
    });
    
    document.getElementById('newOrderForm').addEventListener('submit', (e) => {
        e.preventDefault();
        // 这里添加订单提交逻辑
        alert('Order submitted successfully!');
        orderForm.style.display = 'none';
        document.getElementById('newOrderForm').reset();
    });
    */
});