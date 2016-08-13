From: bobzer <bobzer@gmail.com>
Subject: best kernel ??
Date: Fri, 12 Aug 2016 20:00:11 -0400
Message-ID: <CADzS=arXe-bPGHfGSnAsJ1ysk=1-5XPZ6DFetwynpiv41_56aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I need to update my kernel to get full ext4 support.
I'm on debian, so i compiled my the last stable version 4.7 and also mdadm 3.4
everything is good until i did ./test --keep-going there i got a lot of error
i saw that kernel betwen 4.1 and 4.4 has problems about raid :
http://www.linuxfromscratch.org/blfs/view/svn/postlfs/mdadm.html
So i'm wondering which kernel should i get ?
my debian is jessie (8) and it's a vm in esx, so i don't need to
support a lot of things but at least raid :-)

what version do you run ??
any advice ?

about the compilation i simply download the last version untar
check that mdadm was stop
make
make install
./test -keep-going

the things that i don't understand it's that i ran the test a few time
and never get the same result..

thanks
