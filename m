From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: SSD + Rust as raid1
Date: Sat, 8 Jun 2013 18:58:04 -0300
Message-ID: <CAH3kUhFdYNpnnYYj+h_bcLDNC6U7tMySEYn012P7ZUTP0VXbZQ@mail.gmail.com>
References: <51A7C36F.4030605@timedicer.co.uk>
	<20130531133018.77cd9285@natsu>
	<51A85574.8080709@timedicer.co.uk>
	<20130531135434.5b6bdddb@natsu>
	<51A864E1.9070903@timedicer.co.uk>
	<51ADA1AF.6040405@timedicer.co.uk>
	<51B25D7C.4090403@tmr.com>
	<20130608162235.7ca32f4d@natsu>
	<51B365CA.6090409@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B365CA.6090409@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

check this, maybe could help to improve performace (it's not a raid1
solution, it's a cache solution, in kernel 3.9):

http://kernelnewbies.org/Linux_3.9#head-3dbc54b9324d21f06f55299b0a30d6cb06403529

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/plain/Documentation/device-mapper/cache.txt?id=c6b4fcbad044e6fffcc75bba160e720eb8d67d17
