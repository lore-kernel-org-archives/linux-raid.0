From: Peter <thenephilim13@yahoo.com>
Subject: Re: slow raid5 performance
Date: Mon, 22 Oct 2007 10:18:59 -0700 (PDT)
Message-ID: <780710.47922.qm@web52802.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----

From: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>



Thank you for your insightful response Peter (Yahoo spam filter hid it from me until now). 



> Most 500GB drives can do 60-80MB/s on the outer tracks

> (30-40MB/s on the inner ones), and 3 together can easily swamp

> the PCI bus. While you see the write rates of two disks, the OS

> is really writing to all three disks at the same time, and it

> will do read-modify-write unless the writes are exactly stripe

> aligned. When RMW happens write speed is lower than writing to a

> single disk.



I can understand that if a RMW happens it will effectively lower the write throughput substantially but I'm not sure entirely sure why this would happen while  writing new content, I don't know enough about RAID internals. Would this be the case the majority of time?



> The system time is because the Linux page cache etc. is CPU

> bound (never mind RAID5 XOR computation, which is not that

> big). The IO wait is because IO is taking place.



  http://www.sabi.co.uk/blog/anno05-4th.html#051114



> Almost all kernel developers of note have been hired by wealthy

> corporations who sell to people buying large servers. Then the

> typical system that these developers may have and also target

> are high ends 2-4 CPU workstations and servers, with CPUs many

> times faster than your PC, and on those system the CPU overhead

> of the page cache at speeds like yours less than 5%.



> My impression is that something that takes less than 5% on a

> developers's  system does not get looked at, even if it takes 50%

> on your system. The Linux kernel was very efficient when most

> developers were using old cheap PCs themselves. "scratch your

> itch" rules.



This is a rather unfortunate situation, it seems that some of the roots are forgotten, especially in a case like this where one would think running a file server on a modest CPU should be enough. I was waiting for Phenom and AM2+ motherboards to become available before relegating this X2 4600+ to file server duty, guess I'll need to stay with the slow performance for a few more months. 



> Anyhow, try to bypass the page cache with 'O_DIRECT' or test

> with 'dd oflag=direct' and similar for an alterative code path.



I'll give this a try, thanks.



> Misaligned writes and page cache CPU time most likely.



What influence would adding more harddrives to this RAID have? I know in terms of a Netapp filer they  always talk about spindle count for performance. 



-

To unsubscribe from this list: send the line "unsubscribe linux-raid"  in

the body of a message to majordomo@vger.kernel.org

More majordomo info at  http://vger.kernel.org/majordomo-info.html















