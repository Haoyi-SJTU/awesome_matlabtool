% 向指定邮箱发送指定内容和标题的邮件
% 输入：
% mailtitle 邮件题目 
% mailcontent 邮件内容
function mailme(mailtitle,mailcontent)
mail = 'XXXXXXXX@163.com';  % 邮箱地址
password = 'XXXXXXXX'; % 邮箱授权码

% 服务器设置
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.163.com'); % ③SMTP服务器
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% 发送邮件
receiver='XXXXXX@qq.com'; % ④我的收件邮箱
sendmail(receiver,mailtitle,mailcontent);
end
