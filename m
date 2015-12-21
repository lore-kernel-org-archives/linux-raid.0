From: Tejas Rao <raot@bnl.gov>
Subject: Re: clustered MD - beyond RAID1
Date: Mon, 21 Dec 2015 16:27:00 -0500
Message-ID: <56786EA4.2020209@bnl.gov>
References: <56742652.5040304@nasa.gov>
 <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov>
 <87bn9j4jhr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bn9j4jhr.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

GPFS guarantees that only one node will write to a linux block device 
using disk leases. Only a node with a disk lease has the right to submit 
I/O and disk leases expire every 30 secs and needs to be renewed. Lustre 
and other distributed file systems have other ways of handing this.

Using md devices in a shared/clustered environment is something not 
supported by Redhat on RHEL6 or RHEL7 kernels, so this is something we 
would not try in our production environments.

Tejas.

On 12/21/2015 15:47, NeilBrown wrote:
> On Tue, Dec 22 2015, Tejas Rao wrote:
>
>> What if the application is doing the locking and making sure that only 1
>> node writes to a md device at a time? Will this work? How are rebuilds
>> handled? This would be helpful with distributed filesystems like
>> GPFS/lustre etc.
>>
> You would also need to make sure that the filesystem only wrote from a
> single node at a time (or access the block device directly).  I doubt
> GPFS/lustre make any promise like that, but I'm happy to be educated.
>
> rebuilds are handled by using a cluster-wide lock to block all writes to
> a range of addresses while those stripes are repaired.
>
> NeilBrown

