From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Tue, 14 Feb 2012 09:58:10 +0100
Message-ID: <4F3A2222.8050304@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F39D9B2.3050305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/02/2012 04:49, Stan Hoeppner wrote:
> On 2/13/2012 5:02 PM, keld@keldix.com wrote:
>
>> And anyway, I think a 7 spindle raid10,f2 would be much faster
>> than a md linear array setup, both for small files and for largish
>> sequential files. But try it out and report to us what you find.
>
> The results of the target workload should be interesting, given the
> apparent 7 spindles of stripe width of mdraid10,f2, and only 3
> effective spindles with the linear array of mirror pairs, an apparent
> 4 spindle deficit.
>

If you try to make two simultaneous reads to the same "effective 
spindle", i.e., the same raid pair, won't you get simultaneous reads - 
one from each half of the mirror?  So even though XFS thinks it is 
sitting on three "disks", you'll still get much of the 6 spindle speed? 
  Certainly if the pairs are raid10,f2 then larger reads from the pairs 
will go at double speed as the data is striped in the pair.

>> I would expect  a linear md, and also most other MD raids would
>> tend to perform better in the almost empty state, as the files will
>> be placed on the faster parts of the spindles.
>
> This is not the case with XFS.
>
>> raid10,f2 would have a more uniform performance as it gets filled,
>> because read access to files would still be to the faster parts of
>> the spindles.
>
> This may be the case with EXTx, Reiser, etc, but not with XFS.
>
> XFS creates its allocation groups uniformly across the storage
> device. So assuming your filesystem contains more than a handful of
> directories, even a very young XFS will have directories and files
> stored from outer to inner tracks.
>
> This layout of AGs, and the way XFS makes use of them, is directly
> responsible for much of XFS' high performance.  For example, a
> single file create operation on a full EXTx filesystem will exhibit a
> ~30ms combined seek delay with an average 3.5" SATA disk.  With XFS
> it will be ~10ms.  This is because with EXTx the directories are at
> the outer edge and the free space is on the far inner edge.  With XFS
> the directory and free space area few tracks apart within the same
> allocation group.  Once you seek the directory in the AG, the seek
> latency from there to the track with the free space may be less than
> 1ms.  The seek distance principal here is the same for single disks
> and RAID.
>

For some workloads, the closeness of the data and the metadata will give 
you much lower latencies.  For other workloads, the difference in the 
disk speed between the inner and outer areas will be more significant, 
especially if the metadata is already cached by the system.  For 
metadata-heavy operations, having it all in one place (like with ext) 
will be more efficient.  But for operations involving multiple large 
writes, XFS split over allocation groups will help keep the 
fragmentation low, which is probably part of why it has a good 
reputation for speed when working with very large files.

There is no "one size fits all" filesystem - there are always tradeoffs. 
  That's part of the fun of Linux - you can use the standard systems, or 
you can have your favourite filesystem that you know well and use 
everywhere, or you can learn about them all and try and choose the 
absolute best for each job.
