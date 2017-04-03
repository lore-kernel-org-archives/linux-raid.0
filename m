From: NeilBrown <neilb@suse.com>
Subject: Re: RAID6 rebuild oddity
Date: Mon, 03 Apr 2017 12:09:46 +1000
Message-ID: <87tw66dyxh.fsf@notabene.neil.brown.name>
References: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com> <87zig467z3.fsf@notabene.neil.brown.name> <5584b8b1-b4f1-0d2e-cbf3-f14b4127d031@fnarfbargle.com> <87wpb7612w.fsf@notabene.neil.brown.name> <CAPcyv4gwG6yRMKF4wdhT_cPfCn=eucLX=ON7DWTA2gw0ptgmbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gwG6yRMKF4wdhT_cPfCn=eucLX=ON7DWTA2gw0ptgmbQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Mar 31 2017, Dan Williams wrote:

> On Wed, Mar 29, 2017 at 5:49 PM, NeilBrown <neilb@suse.com> wrote:
>> On Wed, Mar 29 2017, Brad Campbell wrote:
>>
>>> On 29/03/17 12:08, NeilBrown wrote:
>>>
>>>>
>>>> sdj is getting twice the utilization of the others but only about 10%
>>>> more rKB/sec.  That suggests lots of seeking.
>>>
>>> Yes, something is not entirely sequential.
>>>
>>>> Does "fuser /dev/sdj" report anything funny?
>>>
>>> No. No output. As far as I can tell nothing should be touching the disks
>>> other than the md kernel thread.
>>>
>>>> Is there filesystem IO happening? If so, what filesystem?
>>>> Have you told the filesystem about the RAID layout?
>>>> Maybe the filesystem keeps reading some index blocks that are always on
>>>> the same drive.
>>>
>>> No. I probably wasn't as clear as I should have been in the initial
>>> post. There was nothing mounted at the time.
>>>
>>> Right now the array contains one large LUKS container (dm-crypt). This
>>> was mounted and a continuous dd done to the dm device to zero it out :
>>>
>>> 4111195+1 records in
>>> 4111195+1 records out
>>> 34487205507072 bytes (34 TB) copied, 57781.1 s, 597 MB/s
>>>
>>> So there is no filesystem on the drive.
>>>
>>> I failed and removed sdi :
>>>
>>> root@test:~# mdadm --fail /dev/md0 /dev/sdi
>>> mdadm: set /dev/sdi faulty in /dev/md0
>>> root@test:~# mdadm --remove /dev/md0 /dev/sdi
>>> mdadm: hot removed /dev/sdi from /dev/md0
>>> root@test:~# mdadm --zero-superblock /dev/sdi
>>> root@test:~# mdadm --add /dev/md0 /dev/sdi
>>> mdadm: added /dev/sdi
>>>
>>> Rebooted the machine to remove all tweaks of things like stripe cache
>>> size, readahead, NCQ and anything else.
>>>
>>> I opened the LUKS container, dd'd a meg to the start to write to the
>>> array and kick off the resync, then closed the LUKS container. At this
>>> point dm should no longer be touching the drive and I've verified the
>>> device has gone.
>>>
>>> I then ran sync a couple of times and waited a couple of minutes until I
>>> was positive _nothing_ was touching md0, then ran :
>>>
>>> blktrace -w 5 /dev/sd[bcdefgij] /dev/md0
>>>
>>>> So the problem moves from drive to drive?  Strongly suggests filesystem
>>>> metadata access to me.
>>>
>>> Again, sorry for me not being clear. The situation changes on a resync
>>> specific basis. For example the reproduction I've done now I popped out
>>> sdi rather than sdb, and now the bottleneck is sdg. It is the same if
>>> the exact circumstances remain the same.
>>
>> Now *that* is interesting!
>>
>> In the first example you gave, device 0 was rebuilding and device 7 was
>> slow.
>> Now device 6 is rebuilding and device5 is slow.  Surely you see the
>> pattern?
>>
>> Also, I previously observed that the slow device was getting 10% more
>> read traffic, but I was being imprecise.
>> In the first example  it was 16.2%, in the second it is 14.5.
>> These are close to 1/7.
>>
>> There are 8 devices in the array, so there are 8 different layouts for
>> stripes (the parity block can be on 8 different devices).  8 is close to
>> 7.
>>
>> How recovery *should* work on RAID6 is that for each strip we read all
>> blocks except for the Q block (which isn't needed to rebuild a single
>> device) and the block which has failed (of course).  For the stripe
>> where the Q block has failed, we don't read the P block.  Just read all
>> the data and calculate Q from that.
>>
>> So for every 8-device strip, we read from 6 devices.  5 Data plus parity
>> when data has failed, 6 data when P or Q has failed.
>> So across each of the 8 different strip layouts, there are 48 reads
>> Spread across 7 working devices....  using lower-case for blocks that
>> aren't read and assuming first device is being recovered:
>>
>>            d  D  D  D  D  D  P  q
>>            d  D  D  D  D  P  q  D
>>            d  D  D  D  P  q  D  D
>>            d  D  D  P  q  D  D  D
>>            d  D  P  q  D  D  D  D
>>            d  P  q  D  D  D  D  D
>>            p  q  D  D  D  D  D  D
>>            q  D  D  D  D  D  D  p
>> totals:    0  7  7  7  7  7  7  6
>>
>> The device just "before" the missing device gets fewer reads,
>> because we don't need to read P from that device.
>> But we are seeing that it gets more reads.  The numbers suggest that
>> it gets 8 reads (1/7 more than the others).  But the numbers also
>> suggest that it gets lots of seeks.  Maybe after all the other devices
>> have break read for one stripe, md/raid6 decides it does need those
>> blocks and goes back to read them?  That would explain the seeking
>> and the increased number of reads.
>>
>> Time to look at the blktrace...
>> Looking at sdj, each request is Queued 8 times (I wonder why) but the
>> requests are completely sequential.
>>
>>   blkparse sdj* | awk '$6 == "Q" && $8 != prev {print $8, $8-prev ; prev=$8}'  | awk '$2 != 8'
>>
>> This means the 'Q' block is being read.  Not what I expected, but not
>> too surprising.
>>
>> Looking at sdg, which is the problem device:
>>
>>   blkparse sdg* | awk '$6 == "Q" && $8 != prev {print $8-prev ; prev=$8}'  \
>>     | sort | uniq -c | sort -n | tail -60
>>
>> There are lots of places we skip forward 904 sectors.  That is an 8
>> sector read and a 896 sector seek. 896 sectors = 448K or 7 chunks
>> (64K chunk size).
>> These 7-chunk seeks are separated by 16 8-sector reads.  So it seems to
>> be reading all the P (or maybe Q) blocks from a sequence of stripes.
>>
>> There are also lots of large back/forward seeks. They range from -31328
>> to -71280 backward and 27584 to 66408  (with a couple of smaller ones).
>>
>> If we ignore all reads to sdg that are the result of seeking backwards -
>> i.e. that are earlier that the largest offset seen so far:
>>
>>   blkparse sdg* | awk '$6 == "Q" && $8 != prev {if ($8>max) {print $8; max=$8} ; prev=$8}' | awk '{print $1-prev; prev=$1}' | grep  -v 8
>>
>> we seek that (after an initial section) every block is being read.
>> So it seems that sdg is seeking backwards to read some blocks that it
>> has already read.
>>
>> So what really happens in that all the working devices read all blocks
>> (although they don't really need Q), and sdg needs to seek backwards to
>> re-read 1/8 of all blocks, probably the P block.
>>
>> So we should be seeing the rkB/s for the slow disk 1/8 more than the
>> others.  i.e. 12.5%, not 14% or 16%.  The difference bothers me, but not
>> very much.
>>
>> Now to look at the code.
>>
>> need_this_block() always returns 1 when s->syncing, so that is why
>> we already read the Q block.  The distinction between recovery and
>> resync isn't very strong in raid5/6.
>>
>> So on the stripes where Q has failed, we read all the Data and P.
>> Then handle_parity_checks6() notice that there are enough devices that
>> something is worth checking, so it checks the P.  This is destructive!
>> of P.  The D blocks are xored into P and P is checked for all-zero.
>>
>> I always get lost following this next bit....
>> I think that after deciding zero_sum_result is zero, check_state is set
>> to check_state_compute_result.
>> But before that is processed, we go around the loop again and notice
>> that P is missing (because handle_parity_checks6() cleared R5_UPTODATE)
>> so need_this_block() decided that we need to read it back in again.
>> We don't calculate it because we only calculate blocks on failed
>> devices (I'm sure we didn't used to do that).
>> So we read P back in ... just as we see from the trace.
>>
>> Patch below makes the symptom go away in my testing, which confirms
>> that I'm on the right track.
>>
>> Dan Williams changed the code to only recompute blocks from failed
>> devices, way back in 2008.
>> Commit: c337869d9501 ("md: do not compute parity unless it is on a failed drive")
>>
>> Back then we didn't have raid6 in the same code, so the fix was probably
>> fine.
>>
>> I wonder what the best fix is.... Dan... Any thoughts?
>
> First thought is "Wow!" that's a great bit of detective work.

Not many problems allow for that sort of detective work... It is fun
when they come along :-)

>
> Second thought is that since we validated P as being in-sync maybe we
> can flag at is safe for compute and not re-read it. I wish I had
> written a unit test for the condition where we were missing some
> writebacks after computing that lead to commit c337869d9501  ("md: do
> not compute parity unless it is on a failed drive").
>
> However, I think we already have enough information to trust P.
>
>                         /* The only possible failed device holds Q, so it
>                          * makes sense to check P (If anything else were failed,
>                          * we would have used P to recreate it).
>                          */
>
> So I think your patch is actually already correct, would just need
> comment like the following so the exception is clear:
>
>                 /*
>                  * In the raid6 case if the only non-uptodate disk is P
>                  * then we already trusted P to compute the other failed
>                  * drives. It is safe to compute rather than re-read P.
>                  */
>
> Thoughts?

I'm convinced.  If we have all of D and Q, we *must* have read (or
generated) P recently, so we cannot hide an error here.
I extended the comment to explain why we don't always compute missing
blocks.
I've think your response qualifies for a Reviewed-by - hope that's OK.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljhruoACgkQOeye3VZi
gbkpKhAAvy/AWk05WMMbAcDl/DtDdXAmxqR7tqxQ/JNzeoSjSUJT+mxO0DMNHYjT
xgGMaRSBZCQCylhxUb6HauV7AgxyoBkNMQm49O7o3dzluNniesidzaOQkGmHF7ot
IOCN2KUWUuTQ3vSVhAwaLIV8TWamSKg6IbZY/AuWwxF9h/oePuJNZ59GanZVgdrq
eI60IOaBPMXx7u4+n1ORewajfSQRdnNsgI64k9xc7JaI8pHXPQqcYOk64GM/G+qX
CA6lCH+SMqES5OVXcyi432A0jAWqu2tkqeH4GbtsuElE0g1C0Efc9RXnXNIT589g
6BsfQ34lIFX16ZxLZBJ3IhUmeA2NLcdNYurDrunspc9FeCdzU+l21dMWEZmd1AGG
AMCw3Tbz2kYmC5Goy1xe9e2CRTJ7RiM30f7bhbLyBKZyo3fKYb1/zmhUqrYmbguo
n/O6AZKxPn9axb+4BN8D7nVMUfdwXmPl0PO9yYRZKJrmW8tg9gG9hetRFONHZF9E
wPdOnGOMXk2ZMG9xNsE2NgrTjcKZPzrXI7zqztmIF06Qh+g7AUIH50GUEgNpO8Lu
ZHgHr6ZStTHdKR7sQvexGu99y2U1SOWNgDFaE38FuZpYWsPhIbFPSzbI6vTydvz0
yb0GdGh16G/eQRIfYDC85xNbciSQJkk3+azt+ZwN7sMk4BzhpcE=
=YiFW
-----END PGP SIGNATURE-----
--=-=-=--
