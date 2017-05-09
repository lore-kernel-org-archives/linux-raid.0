From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 16:30:35 +0100
Message-ID: <874lwu59pg.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <591171BD.3060707@hesbynett.no> <87efvy73n9.fsf@esperi.org.uk>
        <9306fd68-4eeb-f487-a500-27050050af98@fnarfbargle.com>
        <87wp9q5n49.fsf@esperi.org.uk>
        <7dfa3eff-9194-002d-918b-42fbae865df3@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7dfa3eff-9194-002d-918b-42fbae865df3@buttersideup.com> (Tim
        Small's message of "Tue, 9 May 2017 13:15:46 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, Tim Small spake thusly:

> On 09/05/17 11:40, Nix wrote:
>> I've had disk failures without warning, and
>> non-failed disks with both read and write errors that would not go away,
>> but that SMART reallocation value just stayed stuck at zero through all
>> of it.
>
> Really?  I see them pretty frequently...  Let's see
>
> server1, RAID6 (4 disks), reallocated_sector_ct: 0 9 1 0
> server2, RAID5 (4 disks), reallocated_sector_ct: 0 0 0 0
> server3, RAID6 (5 disks), reallocated_sector_ct: 34 754 15 115 1
> server4, RAID5 (4 disks), reallocated_sector_ct: 0 0 0 0
> server5, RAID5 (4 disks), reallocated_sector_ct: 0 0 0 0
>
> Disk 2 in server3 (which has drives which are a bit long in the tooth)
> is scheduled to be replaced next time I visit that site.
>
> Are you looking at the 'raw' column in the smartctl output?

No, but since they all read all zero:

  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0

this is pretty redundant.

I do see, on all my disks (regardless of hardware versus software RAID
or indeed age, and some of these disks are seven years old):

196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   051    Old_age   Offline      -       0

One figure is much higher:

195 Hardware_ECC_Recovered  -O-RC-   100   064   000    -    2067212
195 Hardware_ECC_Recovered  -O-RC-   100   064   000    -    2088928
195 Hardware_ECC_Recovered  -O-RC-   082   064   000    -    156528817
195 Hardware_ECC_Recovered  -O-RC-   082   065   000    -    156513792

but this is on a bunch of three-month-old Seagate enterprise disks, and
as with the seek error rate Seagate use a deeply bizarre encoding for
this value, and none of the SeaChest programs seem to be able to decode
it.

It appears that the lower the decoded value, the worse things are -- I
have no idea why two of my drives are doing so much worse than two
others on this score. I guess I should keep an eye on them. In any case,
it's going up fast on those two even when the drives are totally idle
and even when I forcibly spin them down... I don't trust this figure to
tell me anything useful at all. SMART, borderline useless as ever.

Aside: in hex these are

001f8b0c
001fdfe0
095470b1
09543600

which rather suggests that the drives have two distinct encodings to me,
with two drives using one encoding and the other two another one,
probably split at the four-hex-digit mark -- but the drives have
identical firmware and the same model number...
