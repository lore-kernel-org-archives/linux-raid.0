From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: Why not just return an error?
Date: Fri, 7 Oct 2016 18:11:37 -0500
Message-ID: <CACsGCyT7pH3OfJFryrNrgSu9bdVJLXQkhuB4y7krHhMa85XNpA@mail.gmail.com>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org> <57F7CC10.3050607@yandex.ru>
 <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org> <57F7DF05.8090605@yandex.ru>
 <a39cdc87-394e-008c-2e50-6df1bd7394da@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a39cdc87-394e-008c-2e50-6df1bd7394da@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Dark Penguin <darkpenguin@yandex.ru>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, keld@keldix.com, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Oct 7, 2016 at 9:43 AM, Phil Turmel <philip@turmel.org> wrote:
> I want to see the relocations growing in my daily logwatch  reports so
> I can use mdadm --replace to maintain the array without *any* loss
> of redundancy.

Is this report something you added to base logwatch?  I don't see any
such report in my daily logwatch.  Maybe you only see this if the
relocations are non-zero?

Let's say one has a RAID-5 and two drives develop bad sectors (in
different areas) at the same time that for whatever reason are not
repairable.  (Or someone ignores errors on one drive long enough that
another develops problems, or someone never did scrubbing so didn't
find out about bad sectors in one drive until multiple drives had bad
sectors.)  OK, you ddrescue the two drives and reassemble the array.
What will a RAID scrub do when it gets to the area that was zeroed?
Clearly the checksum will be invalid for those sections.

        Thanks,

            Eddie
