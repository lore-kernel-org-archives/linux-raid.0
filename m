From: Ric Wheeler <ric@emc.com>
Subject: Re: md: Change ENOTSUPP to EOPNOTSUPP
Date: Sat, 29 Apr 2006 16:23:41 -0400
Message-ID: <4453CB4D.9020907@emc.com>
References: <20060428124313.29510.patches@notabene>	 <1060428025144.30770@suse.de>	 <62b0912f0604280634x7df2a8a5m9022826876446cb6@mail.gmail.com>	 <44524765.6070703@emc.com> <62b0912f0604290650v6fa0759flace16041c26fa003@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604290650v6fa0759flace16041c26fa003@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Molle Bestefich wrote:

> Ric Wheeler wrote:
>
>> You are absolutely right - if you do not have a validated, working
>> barrier for your low level devices (or a high end, battery backed array
>> or JBOD), you should disable the write cache on your RAIDed partitions
>> and on your normal file systems ;-)
>>
>> There is working support for SCSI (or libata S-ATA) barrier operations
>> in mainline, but they conflict with queue enable targets which ends up
>> leaving queuing on and disabling the barriers.
>
>
> Thank you very much for the information!
>
> How can I check that I have a validated, working barrier with my
> particular kernel version etc.?
> (Do I just assume that since it's not SCSI, it doesn't work?)

The support is in for all drive types now, but you do have to check.

You should look in /var/log/messages and see that you have something 
like this:

  Mar 29 16:07:19 localhost kernel: ReiserFS: sda14: warning: reiserfs: 
option "skip_busy" is set
  Mar 29 16:07:19 localhost kernel: ReiserFS: sda14: warning: allocator 
options = [00000020] 
  Mar 29 16:07:19 localhost kernel:
  Mar 29 16:07:19 localhost kernel: ReiserFS: sda14: found reiserfs 
format "3.6" with standard journal
  Mar 29 16:07:19 localhost kernel: ReiserFS: sdc14: Using r5 hash to 
sort names
  Mar 29 16:07:19 localhost kernel: ReiserFS: sda14: using ordered data mode
  Mar 29 16:07:20 localhost kernel: reiserfs: using flush barriers

You can also do a sanity check on the number of synchronous IO's/second 
and make sure that it seems sane for your class of drive.  For example, 
I use a simple test which creates files, fills them and then fsync's 
each file before close. 

With the barrier on and write cache active, I can write about 30 (10k) 
files/sec to a new file system.  I get the same number with no barrier 
and write cache off which is what you would expect.

If you manually mount with barriers off and the write cache on however, 
your numbers will jump up to about 852 (10k) files/sec.  This is the one 
to look out for ;-)

>
> I find it, hmm... stupefying?  horrendous?  completely brain dead?  I
> don't know..  that noone warns users about this.  I bet there's a
> million people out there, happily using MD (probably installed and
> initialized it with Fedora Core / anaconda) and thinking their data is
> safe, while in fact it is anything but.  Damn, this is not a good
> situation..

The wide spread use of the write barrier is pretty new stuff.  In 
fairness, the accepted wisdom is (and has been for a long time) to 
always run with write cache off if you care about your data integrity 
(again, regardless of MD or native file system). Think of the write 
barrier support as a great performance boost (I can see almost a 50% win 
in some cases), but getting it well understood and routinely tested is 
still a challenge.

>
> (Any suggestions for a good place to fix this?  Better really really
> really late than never...)

Good test suites and lots of user testing...

ric

