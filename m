From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Sequential writing to degraded RAID6 causing a lot of reading
Date: Wed, 23 May 2012 21:01:09 +0200
Message-ID: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello boys,

I am running some RAID6 arrays in degraded mode, one with
left-symmetry layout and one with left-symmetry-6 layout. I am
experiencing (potentially strange) behavior that degrades performance
of both arrays.

When I am writing sequentially a lot of data to healthy RAID5 array,
it also reads internally a bit of data. I have data on arrays, so I
only write through the filesystem. So I am not sure what causing the
reads, if writing through filesystem potentially causes skipping and
not writing whole stripes  or sometimes timing causes that the whole
stripe is not written at the same time. But anyway there is only a
small ratio of reads and the performance is almost OK.

I cant test it with full healthy RAID6 array, because I dont have any
at the moment.

But when I write sequentially to RAID6 without one drive (again
through filesystem) I get almost exactly the same amount of internal
reads as writes. Is it by design and is this expected behaviour? Why
does it behave like this? It should behave exactly like healthy RAID5,
it should detect the writing of whole stripe and should not read
(almost) anything.

Thanks.

Patrik
