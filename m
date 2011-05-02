From: David Brown <david@westcontrol.com>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 11:05:34 +0200
Message-ID: <ipls2e$u97$1@dough.gmane.org>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net> <1304051980.3105.46.camel@localhost> <8739kyf53e.fsf@servo.factory.finestructure.net> <1304294457.2833.111.camel@localhost>  <4DBDFE0C.3000304@fifthhorseman.net> <1304298258.2833.125.camel@localhost> <87pqo1ewa5.fsf@servo.factory.finestructure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pqo1ewa5.fsf@servo.factory.finestructure.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/2011 03:17, Jameson Graef Rollins wrote:
> On Mon, 02 May 2011 02:04:18 +0100, Ben Hutchings<ben@decadent.org.uk>  wrote:
>> On Sun, 2011-05-01 at 20:42 -0400, Daniel Kahn Gillmor wrote:
>> So far as I'm aware, the RAID may stop working, but without loss of data
>> that's already on disk.
>
> What exactly does "RAID may stop working mean"?  Do you mean that this
> bug will be triggered?  The raid will refuse to do further syncs?  Or do
> you mean something else?
>
>>> How is an admin to know which I/O capabilities to check before adding a
>>> device to a RAID array?  When is it acceptable to mix I/O capabilities?
>>>   Can a RAID array which is not currently being used as a backing store
>>> for a filesystem be assembled of unlike disks?  What if it is then
>>> (later) used as a backing store for a filesystem?
>> [...]
>>
>> I think the answers are:
>> - Not easily
>> - When the RAID does not have another device on top
>
> This is very upsetting to me, if it's true.  It completely undermines
> all of my assumptions about how software raid works.
>
> Are you really saying that md with mixed disks is not possible/supported
> when the md device has *any* other device on top of it?  This is a in
> fact a *very* common setup.  *ALL* of my raid devices have other devices
> on top of them (lvm at least).  In fact, the debian installer supports
> putting dm and/or lvm on top of md on mixed disks.  If what you're
> saying is true then the debian installer is in big trouble.
>
> jamie.

I can't imagine that this is the case - layered setups are perfectly 
standard.  While the dm-layer might be less used, it is normal practice 
to have lvm on top of md raids, and it is not uncommon to have more than 
one md layer (such as raid50 setups).  It is also perfectly reasonable 
to through USB media into the mix (though depending on the 
kernel/distro, there may be boot issues if the USB disk is not stable 
fast enough during booting - I had such problems with a USB disk in an 
LVM setup without md raid).

As far as I understand it, there are two sorts of communication between 
the layers of the block devices.  There is the block device access 
itself - the ability to read and write blocks of data.  And there is the 
metadata, covering things like sizes, stripe information, etc.  Only the 
block access is actually needed to get everything working - the other 
information is used for things like resizing, filesystem layout 
optimisation, etc.

The whole point of the layered block system is that the block access 
layers are independent and isolated.  So if you have a dm layer on top 
of an md layer, then the dm layer should not care how the md layer is 
implemented - it just sees a /dev/mdX device.  It doesn't matter if it's 
a degraded raid1 or anything else.  As long as the /dev/mdX device stays 
up, it should not matter that you add or remove devices, or what type of 
underlying device is used.

Similarly, the md raid1 layer is mainly interested in the block access - 
it will work with any block devices.  It will use the metadata to 
improve things like resizes, and perhaps to optimise accesses, but it 
should work /correctly/ (though perhaps slower than optimal) regardless 
of the mix of disks.


I have used layered setups and odd block devices (such as loopback 
devices on files on a tmpfs mount and multiple md layers) - getting 
resizing to work properly involved a little more effort, but it all 
worked perfectly.  I haven't tried such a mix as the OP has been describing.


If my understanding of the block layers is wrong, then I too would like 
to know - running lvm on top of md raid is essential capability, as is 
using USB disks as temporary additions to an array.


