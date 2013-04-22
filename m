From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Mon, 22 Apr 2013 13:19:29 +0300
Message-ID: <5a749bb56c88b6d6b8a806694b163bda@redhost.ro>
References: <5171CBF9.9020701@redhost.ro>
 <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro>
 <51747382.1010105@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51747382.1010105@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

First off allow me to apologize if my rumbling sent you in a wrong 
direction and thank you for assisting.

Most of the data I have supplied was mostly background information. Let 
me start fresh but first allow me to answer your explicit questions:

1. Yes, I own the hardware and it's colocated in a datacenter.
2. I am quite happy with 260MB/s read for SATA2. I think that's decent 
and I never meant it as a problem.
3. I have run for a few minutes iostat -x -m 2 and from what I see the 
normal write per second is at about 0-500KB/s, sometimes it gets to 
1-2MB/s and rarely between 3 and 4MB/s.
4. I will redo the test off-peak hours when I can afford to shutdown 
various services.

The actual problem is that when I write any larger file hundreds of MB 
or more to the server (from network or from the same server) the server 
starts to overload. The server can overload to over 100 for files of ~ 
5GB. I mean this server has an average load of 0.52 (sar -q) but it can 
spike to 3 digit server loads in a few minutes from making or 
downloading a larger cPanel backup file. I have to rely only on R1Soft 
for backups right now because the normal cPanel backups make the server 
unstable when it backs up accounts over 1GB (many).

So I concluded this is due to very low write speeds so I ran the 'dd' 
tests to evaluate this assumption. You know, I don't think that the 
problem is I ran these tests during other I/O intensive tasks. It's like 
after a number of megabytes written at a time, the SSD devices 
themselves overload. I mean during off peak hours I can sometimes get a 
good decent speed (like 60-100MB/s write speed) but if I redo the test 
soon (tens of seconds - minutes) I get very different much lower write 
speeds (like under 10MB/s write speed). Or maybe the write speed itsef 
is not the problem but the fact that when I write a large file the 
server seems to stop doing anything else. So...the speed test results 
are poor AND the server overloads. A lot! I mean most write results are 
in the 10-20MB/s range. I have seen more than 25MB/s very rarely and 
almost never was I able to reproduce them within the same hour. If I do 
a 'dd' test with 'bs' of 2-4MB I sometimes get good results (40-60MB/s) 
but never with a 'bs' of 1GB (the top speed I got with 1G 'bs' was 
27MB/s during the night). But the essential notable problem is that this 
server can't copy large files without seriously overloading itself.

Now let me elaborate why I have given the read speeds (as I am not 
unhappy with them):
1. Some said the low write speed might be due to a bad cable. So I 
stated the 260MB/s read speed to show it's probably not a bad cable. If 
it's capable to push 260MB/s up, it's probably not a bad cable.
2. I have observed a very big difference between /dev/sda and /dev/sdb 
and I thought it might me indicative of a problem somewhere. If I run 
hdparm -t /dev/sda I get about 215MB/s but on /dev/sdb I get about 
80-90MB/s. Only if I add --direct flag I get 260MB/s for /dev/sda. 
Previously when I added --direct for /dev/sdb I was getting about 
180MB/s but now I get ~85MB/s with or without --direct.

root [/]# hdparm -t /dev/sdb
Timing buffered disk reads:  262 MB in  3.01 seconds =  86.92 MB/sec

root [/]# hdparm --direct -t /dev/sdb
Timing O_DIRECT disk reads:  264 MB in  3.08 seconds =  85.74 MB/sec

This is something new. /dev/sdb no longer gets to nearly 200MB/s (with 
--direct) but stays under 100MB/s in all cases. Maybe indeed it's a 
problem with the cable or with the device itself.

And a 30 minutes later update: /dev/sdb returned to 90MB/s read speed 
WITHOUT --direct and 180MB/s WITH --direct. /dev/sda is constant (215 
without --direct and 260 with --direct). What do you make of this?

Kind regards!

On 2013-04-22 02:17, Stan Hoeppner wrote:
> On 4/21/2013 3:46 PM, Andrei Banu wrote:
>> Hello,
>> At this point I probably should state that I am not an experienced
>> sysadmin.
> Things are becoming more clear now.
> 
>> Knowing this, I do have a server management company but they
>> said they don't know what to do
> So you own this hardware and it is colocated, correct?
> 
>> so now I am trying to fix things myself
>> but I am something of a noob. I normally try to keep my actions to
>> cautious config changes and testing.
> Why did you choose Centos?  Was this installed by the company?
> 
>> I have never done a kernel update.
>> Any easy way to do this?
> It may not be necessary, at least to solve any SSD performance 
> problems
> anyway.  Reexamining your numbers shows you hit 262MB/s to /dev/sda.
> That's 65% of SATA2 interface bandwidth, so this kernel probably does
> have the patch.  Your problem lie elsewhere.
> 
>> Regarding your second advice (to purchase a decent HBA) I have 
>> already
>> thought about it but I guess it comes with it's own drivers that need 
>> to
>> be compiled into initramfs etc.
> The default CentOS (RHEL) initramfs should include mptsas, which
> supports all the LSI HBAs.  The LSI caching RAID cards are supported 
> as
> well with megaraid_sas.
> The question is, do you really need more than the ~260MB/s of peak
> throughput you currently have?  And is it worth the hassle?
> 
>> So I am trying to replace the baseboard
>> with one with SATA3 support to avoid any configuration changes (the 
>> old
>> board has the C202 chipset and the new one has C204 so I guess this
>> replacement is as simple as it gets - just remove the old board and 
>> plug
>> the new one without any software changes or recompiles). Again I need 
>> to
>> say this server is in production and I can't move the data or the 
>> users.
>> I can have a few hours downtime during the night but that's about 
>> all.
> It's not clear your problem is hardware bandwidth.  In fact it seems 
> the
> problem lie elsewhere.  It may simply be that you're running these 
> tests
> while other substantial IO is occurring.  Actually, your numbers show
> this is exactly the case.  What they don't show is how much other IO 
> is
> hitting the SSDs while you're running your tests.
> 
>> Regarding the kernel upgrade, do we need to compile one from source 
>> or
>> there's an easier way?
> I don't believe at this point you need a new kernel to fix the problem
> you have.  If this patch was not present you'd not be able to get
> 260MB/s from SATA2.  Your problem lie elsewhere.
> In the future, instead of making a post saying "md is slow, my SSDs 
> are
> slow" and pasting test data which appears to back that claim, you'd be
> better served by describing a general problem, such as "users say the
> system is slow and I think it may be md or SSD related".  This way we
> don't waste time following a troubleshooting path based on incorrect
> assumptions, as we've done here.  Or at least as I've done here, as 
> I'm
> the only one assisting.
> Boot all users off the system, shut down any daemons that may generate
> any meaningful load on the disks or CPUs.  Disable any encryption or
> compression.  Then rerun your tests while completely idle.  Then we'll
> go from there.
> --
> Stan
> 
> 
>> Thanks!
>> On 21/04/2013 3:09 AM, Stan Hoeppner wrote:
>>> On 4/19/2013 5:58 PM, Andrei Banu wrote:
>>> 
>>>> I come to you with a difficult problem. We have a server otherwise
>>>> snappy fitted with mdraid-1 made of Samsung 840 PRO SSDs. If we 
>>>> copy a
>>>> larger file to the server (from the same server, from net doesn't
>>>> matter) the server load will increase from roughly 0.7 to over 100 
>>>> (for
>>>> several GB files). Apparently the reason is that the raid can't 
>>>> write
>>>> well.
>>> ...
>>>> 547682517 bytes (548 MB) copied, 7.99664 s, 68.5 MB/s
>>>> 547682517 bytes (548 MB) copied, 52.1958 s, 10.5 MB/s
>>>> 547682517 bytes (548 MB) copied, 75.3476 s, 7.3 MB/s
>>>> 1073741824 bytes (1.1 GB) copied, 61.8796 s, 17.4 MB/s
>>>> Timing buffered disk reads:  654 MB in  3.01 seconds = 217.55 
>>>> MB/sec
>>>> Timing buffered disk reads:  272 MB in  3.01 seconds =  90.44 
>>>> MB/sec
>>>> Timing O_DIRECT disk reads:  788 MB in  3.00 seconds = 262.23 
>>>> MB/sec
>>>> Timing O_DIRECT disk reads:  554 MB in  3.00 seconds = 184.53 
>>>> MB/sec
>>> ...
>>> Obviously this is frustrating, but the fix should be pretty easy.
>>> 
>>>> O/S: CentOS 6.4 / 64 bit (2.6.32-358.2.1.el6.x86_64)
>>> I'd guess your problem is the following regression.  I don't believe
>>> this regression is fixed in Red Hat 2.6.32-* kernels:
>>> http://www.archivum.info/linux-ide@vger.kernel.org/2010-02/00243/bad-performance-with-SSD-since-kernel-version-2.6.32.html
>>> 
>>> After I discovered this regression and recommended Adam Goryachev
>>> upgrade from Debian 2.6.32 to 3.2.x, his SSD RAID5 throughput 
>>> increased
>>> by a factor of 5x, though much of this was due testing methods.  His 
>>> raw
>>> SSD throughput more than doubled per drive.  The thread detailing 
>>> this
>>> is long but is a good read:
>>> http://marc.info/?l=linux-raid&m=136098921212920&w=2
>>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

