From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUG (Deadlock) in 2.6.10
Date: Tue, 8 Mar 2005 15:52:58 +1100
Message-ID: <16941.12202.371961.452459@cse.unsw.edu.au>
References: <4221E874.6060309@rapidforum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Christian Schmid on Sunday February 27
Sender: linux-raid-owner@vger.kernel.org
To: Christian Schmid <webmaster@rapidforum.com>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 27, webmaster@rapidforum.com wrote:
> Hello.
> 
> Just for your information: There is a deadlock in the following situation:
> 
> MD2 is Raid 0 with 3 disks. sda1 sdb1 sdc1
> MD3 is Raid 0 with 3 disks. sdd1 sde1 sdf1
> MD4 is Raid 1 with 2 disks. MD2 and MD3!!
> 
> If a disk in MD2 fails, MD2 completely fails. MD4 SHOULD now mark disk 1 (MD2) as faulty but does 
> not. Instead there is a dead-lock. "sync" hangs as well. Had to
> reboot.

Sorry for the delay in replying.

I cannot reproduce this. disk '1' of md4 (which is md2) gets moved to
position '2' and marked faulty.

You are running a pure 2.6.10 kernel are you? no patches at all?
Any other details you could provide?


> 
> I am now using the native Raid 10. Is this stable enough?

Should be.... It hasn't had as much testing as raid1, but I'm glad you
are helping out by giving it a bit more....

NeilBrown


> 
> Best regards,
> Chris - RapidTec
