From: Keith Roberts <keith@karsites.net>
Subject: Re: mdadm crashing server?
Date: Mon, 28 Apr 2008 06:24:03 +0100 (BST)
Message-ID: <alpine.LFD.1.10.0804280619240.5431@www.karsites.net>
References: <00c801c8a8e8$a1dc5670$0405a8c0@hp>
Reply-To: Keith Roberts <keith@karsites.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00c801c8a8e8$a1dc5670$0405a8c0@hp>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Apr 2008, Luke Sheldrick wrote:

> To: linux-raid@vger.kernel.org
> From: Luke Sheldrick <luke@sheldrick.co.uk>
> Subject: mdadm crashing server?
> 
> Hi all,
>
> Have a niggling problem on my home nas at the moment.
>
> I rebuilt a raid 1 array a few nights ago, and haven't 
> managed to get the disc's to resync since creating a ext3 
> fs on the array.
>
> It would seem that as soon as they try to resync it 
> crashes the server, totally. All networking stops, not 
> responsive at the console.
>
> If I keep the array up with a single disc (doesn't matter 
> which) then all is fine.
>
> There is another raid on the server using mdadm which runs fine.
>
> Any ideas?
>
> Background:
> Server running FC8, up to date on testing tree, although same problem on 
> stable.
> The two disc's are on the tertiary ide (master, slave). Both maxtor 
> 250gb.
> Server, Dell Poweredge 600sc.
>
> Thanks

From the Linux software raid howto: It is not recommended to 
run the same RAID1 array on the same IDE cable as 
master/slave. In fact the howto recommends 1 drive set as 
master on one cable only. One reason being if your master
drive goes down, then the slave may not operate correctly.

Kind Regards,

Keith Roberts

-----------------------------------------------------------------
Websites:
http://www.php-debuggers.net
http://www.karsites.net
http://www.raised-from-the-dead.org.uk

All email addresses are challenge-response protected with
TMDA [http://tmda.net]
-----------------------------------------------------------------
