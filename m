From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: Recommendation on new system Arrays
Date: Tue, 10 Jan 2017 02:48:22 -0600
Message-ID: <bfb6ebec-defe-186d-76c8-f7fbbaf65a70@gmail.com>
References: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
 <d1f5b65b-5a0b-92e1-7fe7-d2a0c45c8998@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d1f5b65b-5a0b-92e1-7fe7-d2a0c45c8998@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/08/2017 10:34 PM, Brad Campbell wrote:
>
> This can be a real trap.
>
> In general CCTV software works great for about the first 2 complete database writes. As the database ages you will find increasing levels of write fragmentation that kill your write latency. It also makes each write smaller as you are no longer streaming bulk data to disk but filling the holes left by expired footage. This destroys your array write latency and makes replay and searching for footage frustratingly slow.
>
> Make sure your CCTV storage RAID is not used for anything else, select a small chunk size to minimise stripe size and be prepared for fairly high search and playback latency.
>
> Most of the major CCTV systems suffer in the same way, and they generally get around it by using "hardware" RAID cards with large RAM buffers (until the BBU wears out and you start getting massive footage loss because they can't get the streams to disk fast enough).
>
> If performance is not an issue then a RAID6 being written from a Windows VM on a Linux host works just fine. Pass the md straight through to the Windows VM and let it manage the raw block device.
>
> It has bee a couple of years since I tested Milestone, but I've just finished a test with Indigo Vision, Aimetis, Genetec, Geutebruck, Bosch, Avigilon & March Networks. They all suffer to a certain degree and all use different storage architectures depending on their legacy. March works really well over SMB shares though. I'm just not fond of the product.
>
> Milestone sent me a new test license before Christmas but I've not got around to spooling it up yet.
>
> All of this stuff gets tested on KVM VM's writing to a couple of small RAID-6 arrays (10-14 drives).

Excellent -- the kind of info I was looking for (and wondering about.)

Thanks for the tip!

 -Ben


