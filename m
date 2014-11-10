From: Jason Keltz <jas@cse.yorku.ca>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Sun, 09 Nov 2014 22:20:22 -0500
Message-ID: <54602EF6.9070909@cse.yorku.ca>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org> <545CEDFB.6060806@gautschi.net> <545D8FBA.9090701@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545D8FBA.9090701@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2014 10:36 PM, Phil Turmel wrote:
> On 11/07/2014 11:06 AM, P. Gautschi wrote:
>>  > This is a problem you haven't solved yet, I think. The raid array
>> should have fixed this bad sector for you without kicking the drive out.
>> The scenario is common with "green" drives and/or consumer-grade drives
>> in general.
>>  > ...
>>  > Then you can set up your array to properly correct bad sectors, and
>> set your system to look for bad sectors on
>>  > a regular basis.
>>
>> What is the behavior of mdadm when a disk reports a read error?
>> - reconstruct the data, deliver it to the fs and otherwise ignore it?
>> - set the disk to fail?
>> - reconstruct the data, rewrite the failed data and continue with any
>> action?
>> - rewrite the failed data and reread it (bypassing the cache on the HD)?
>
> Option 3.  Reconstruct and rewrite.
>
> However, if the device with the bad sector is trying to recover longer 
> than the linux low level driver's timeout, bad things^TM happen. 
> Specifically, the driver resets the SATA (or SCSI) connection and 
> attempts to reconnect.  During this brief time, it will not accept 
> further I/O, so the write back of the reconstructed data fails.  Then 
> the device has experienced a *write* error, so MD fails the drive.  
> This is the out-of-the-box behavior of consumer-grade drives in raid 
> arrays.

Hi Phil,
Sorry to interject..
Since I'm in the midst of setting up a 22 disk RAID 10 with 2 TB WD 
black (desktop) drives, I wanted to be clear that I understand this 
particular scenerio that you bring up.  Should a drive enter a deep 
error recovery, would I be correct that the worst that should happen 
would be a hang for the users during this recovery time, and, if the 
driver does reset the SATA connection (as it likely would do), then a 
potential removal of the disk from the array, but not the destruction of 
the array?  If I had a spare disk, it would be used for a potential 
rebuild, but I could test the original disk and re-add it back to the 
pool at another time.

Any feedback would be helpful.

Thanks!

Jason.

