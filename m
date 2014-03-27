From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size
Date: Thu, 27 Mar 2014 13:04:38 +0000
Message-ID: <BLU0-SMTP3519F2E4A6D063A11B2848798670@phx.gbl>
References: <tencent_66C345191B9B49B92956F243@qq.com>
	 <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se>
	 <loom.20140326T205013-837@post.gmane.org>
	 <53334347.4050108@hardwarefreak.com>
	 <loom.20140327T033039-0@post.gmane.org>
	 <5333BC86.8090205@hardwarefreak.com>
	 <loom.20140327T070926-524@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20140327T070926-524@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tide <lovetide@qq.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2014-03-27 at 06:41 +0000, Tide wrote:
> Stan Hoeppner <stan <at> hardwarefreak.com> writes:
> 
> > 
> > > "The RAID6/RAID5 array", do you mean my RAID array (just this instance), or
> > > you mean "all RAID6/RAID5 arrays created by mdadm" ?
> > 
> > My reply above is unambiguous.  I quoted your array data and gave an
> > answer that applies to your provided array data.
> > 
> > WRT your other questions, I do not have time to research the answer to
> > those, and wouldn't spend it on that if I did.  I have never used CentOS
> > nor Fedora, and don't plan to ever use either.  For those answers,
> > either wait for someone to answer, or research it yourself.
> > 
> > Cheers,
> > 
> > Stan
> 
> Thank you Stan!
> 
> Now I'm going to try remove the write-intent bitmap and bad block log in the
> RAID 6 array to reshape two arrays to same size.

I'm not 100% certain but I doubt that will have any effect, once an
array is created its basic structural layout on individual disks is set
and from what I can tell is usually dependent on which version was used
to create the array, although I do recall that after updating my debian
and therefore mdadm through various levels the on disk basic structure,
such as offset, also changed on new devices that were added to existing
arrays... hence why there is (was?) a special version of mdadm that
allows entering offsets on individual members for use in some recovery
situations.

I think that even if at the creation time of a new array, you tell it no
write intent and no bad blocks (not sure if bad blocks can be removed)
it will still reserve space in case you want to use them at another
time.

If you want exactly the same space/size then you would need to create
with the original os/mdadm versions previously used... but even so I'm
not sure that disk/partition size plays a part in initial layout (I
don't think it does, but I may be wrong) so creating a new array on say
3GB disks as apposed to 1GB disks "might" cause a different size/layout.

Personally I wouldn't worry about minor differences in overall size,
especially concidering that the only time it would make a difference
would be if you were copying one to the other using a regular transfer
(cp/rsync/etc) and the original array was full (100% full) and the
second array was slightly smaller, although adjusting the file system
"root" reserve space on ext3/4 on the new array might mitigate the
problem.

Jon.

