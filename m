From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Tue, 23 Apr 2013 02:11:04 +0300
Message-ID: <5175C388.2050500@redhost.ro>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51747382.1010105@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again!

I have closed all the load generating services, waited a few minutes for 
the server load to reach a clean 0.00 and then I have re-performed the 
dd tests with various bs sizes. I was not able to setup correctly fio 
with a compile error but I'll get it done.

One more thing before the results: I omitted to answer something earlier 
today. CentOS was installed due to fact that cPanel is not installable 
on many OSes (CentOS, RHEL and I think that's about it). So I picked 
CentOS. The installation was done remotely over KVM with a minimal 
CentOS CD (datacenter does not offer any server related services so we 
had to do it ourselves over a Raritan KVM).

Tests were done roughly 1 minute apart.

1. First test (bs=1G): same as always.
root [~]# dd if=testfile.tar.gz of=test oflag=sync bs=1G
547682517 bytes (548 MB) copied, 53.3767 s, 10.3 MB/s

2. With a bs of 4MB: niceeee! Best result ever. I am not sure what 
happened this time. However it's short lived.
root [~]# dd if=testfile.tar.gz of=test2 oflag=sync bs=4M
547682517 bytes (548 MB) copied, 4.43305 s, 124 MB/s

3. bs=2MB, starting to decay.
root [~]# dd if=testfile.tar.gz of=test3 oflag=sync bs=2M
547682517 bytes (548 MB) copied, 20.3647 s, 26.9 MB/s

4. bs=4MB again. Back to square 1.
root [~]# dd if=testfile.tar.gz of=test4 oflag=sync bs=4M
547682517 bytes (548 MB) copied, 56.7124 s, 9.7 MB/s

As services were shut down prior to the test, the biggest load it 
reached was about 2.

5. Finally I restarted the services and redone the bs=4MB test (going 
from a load of 0.23):
root [~]# dd if=testfile.tar.gz of=test6 oflag=sync bs=4M
547682517 bytes (548 MB) copied, 116.469 s, 4.7 MB/s

Again, I don't think my problem is related to any concurrent I/O 
starvation. These SSDs or this mdraid or I don't know what simply can't 
take any sustained write task. And this is not due to the server load. 
Even during very low server loads it's enough to write about 1GB of data 
within a short time frame (minutes) to bring the I/O system to it's 
knees for a considerable time (at least tens of minutes).

4.7MB per second for writing a 548MB file starting from a load of 0.23 
during off peak hours on SSDs. Nice!!!

Thanks!

On 22/04/2013 2:17 AM, Stan Hoeppner wrote:
> On 4/21/2013 3:46 PM, Andrei Banu wrote:
>> Hello,
>>
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
> It may not be necessary, at least to solve any SSD performance problems
> anyway.  Reexamining your numbers shows you hit 262MB/s to /dev/sda.
> That's 65% of SATA2 interface bandwidth, so this kernel probably does
> have the patch.  Your problem lie elsewhere.
>
>> Regarding your second advice (to purchase a decent HBA) I have already
>> thought about it but I guess it comes with it's own drivers that need to
>> be compiled into initramfs etc.
> The default CentOS (RHEL) initramfs should include mptsas, which
> supports all the LSI HBAs.  The LSI caching RAID cards are supported as
> well with megaraid_sas.
>
> The question is, do you really need more than the ~260MB/s of peak
> throughput you currently have?  And is it worth the hassle?
>
>> So I am trying to replace the baseboard
>> with one with SATA3 support to avoid any configuration changes (the old
>> board has the C202 chipset and the new one has C204 so I guess this
>> replacement is as simple as it gets - just remove the old board and plug
>> the new one without any software changes or recompiles). Again I need to
>> say this server is in production and I can't move the data or the users.
>> I can have a few hours downtime during the night but that's about all.
> It's not clear your problem is hardware bandwidth.  In fact it seems the
> problem lie elsewhere.  It may simply be that you're running these tests
> while other substantial IO is occurring.  Actually, your numbers show
> this is exactly the case.  What they don't show is how much other IO is
> hitting the SSDs while you're running your tests.
>
>> Regarding the kernel upgrade, do we need to compile one from source or
>> there's an easier way?
> I don't believe at this point you need a new kernel to fix the problem
> you have.  If this patch was not present you'd not be able to get
> 260MB/s from SATA2.  Your problem lie elsewhere.
>
> In the future, instead of making a post saying "md is slow, my SSDs are
> slow" and pasting test data which appears to back that claim, you'd be
> better served by describing a general problem, such as "users say the
> system is slow and I think it may be md or SSD related".  This way we
> don't waste time following a troubleshooting path based on incorrect
> assumptions, as we've done here.  Or at least as I've done here, as I'm
> the only one assisting.
>
> Boot all users off the system, shut down any daemons that may generate
> any meaningful load on the disks or CPUs.  Disable any encryption or
> compression.  Then rerun your tests while completely idle.  Then we'll
> go from there.
>

