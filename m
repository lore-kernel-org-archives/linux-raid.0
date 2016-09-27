From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Tue, 27 Sep 2016 12:24:51 -0500
Message-ID: <f7d4741d-d780-8e37-6359-e73b3ad0d0bc@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
 <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
 <20160927213624.739f80ba@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160927213624.739f80ba@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/27/2016 11:36 AM, Roman Mamedov wrote:
> On Tue, 27 Sep 2016 11:27:13 -0500
> Benjammin2068 <benjammin2068@gmail.com> wrote:
>
>> I think I did find the problem. The card was running hot due to airflow.
>> That's been remedied (I hope) -- the temp sensor on the heat-sink for the
>> PCIe controller now sits around 45'C which is fine. Before it was >=
>> 60'C . :O
> I wouldn't trust such controller anyway. 15 degrees difference and it
> (allegedly) gives you silent data corruption? What if you have a particularly
> hot day, and/or the AC is out for a few hours.
> There is a lot of better failure modes than this (honestly reported read or
> CRC errors for a start, or heck, even complete lock-up of the controller would
> be more preferrable).
>

I think it was running way hotter than that. I could only get to it to measure in a certain timespan and it had already cooled off. (that's what heatsinks do)

by the time I got a temp sensor on it -- it was too late.

  -Ben
