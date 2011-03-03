From: Roberto Spadim <roberto@spadim.com.br>
Subject: ideas - raid write
Date: Thu, 3 Mar 2011 19:45:00 -0300
Message-ID: <AANLkTimd08XFTZ+x2id5f=a=UCSfZi1y_qQGw0wKj18A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, i have some questions...
how write works in raid1?
md send write to all mirrors and wait write end to return 'ok' to filesystem?
could we send write to mirrors and return with one 'ok'? like a async write?

-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
