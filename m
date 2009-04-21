From: Johannes Segitz <johannes.segitz@gmail.com>
Subject: Re: Performance of a software raid 5
Date: Tue, 21 Apr 2009 02:10:49 +0200
Message-ID: <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	 <49ED096E.1000002@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49ED096E.1000002@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 21, 2009 at 1:46 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> I would have thought it's because you're running in degraded mode and one in
> 3 sectors is having to be regenerated from the parity. It still seems a bit
> slow, though.

i don't think that that is a problem. The data is there without
redundancy so i can't see
how there would be the need to calculate anything

> I'm not quite sure whether I should be disappointed at my writes being so
> slow. Certainly there's a lot of rattling during writing, which probably
> indicates lots of seeks to write ext3's journal. But reads are roughly what
> I expected, at about three times the single-disc throughput.

200 MB/s reads would be nice but i expected quite a bit more speed
writing too. I know
that you don't get an O(n) speedup but falling behind the normal performance of
a single drive seems not okay.

Johannes
Btw.:The controller is on PCI-E so no bottleneck there
