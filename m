From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Tue, 27 Sep 2016 11:27:13 -0500
Message-ID: <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/27/2016 04:16 AM, Brad Campbell wrote:
> On 27/09/16 09:08, Benjammin2068 wrote:
>>
>
>> Also, I just did a "repair" and the mismatch is now back to 8... which seems like a suspicious number considering the filesystem on this new drive (because it's a WD10 series with 4096byte sectors) has a slightly larger FS than the Samsung HD103SJ (and Seagate equivalents) in the array too.
>
> See that is a bad thing to do if you even remotely suspect you have a problem. All a "repair" does is check the parity on a stripe and if there is a mismatch it re-writes it. You are writing to an array that apparently has issues.
>
> I'd be checking the filesystem and file contents very carefully for corruption, and running several sequential check actions to keep an eye on the mismatch count.
>

Yep.

Once I reconfig'd the hardware and checked the cables in the system on boot the number is now 0. (which makes sense at boot - but is creepy) I put a monitor into munin which I'll be watching closely for when it changes.

BUT... I think I did find the problem. The card was running hot due to airflow. That's been remedied (I hope) -- the temp sensor on the heat-sink for the PCIe controller now sits around 45'C which is fine. Before it was >= 60'C . :O

Thanks again everyone,

 -Ben

p.s. The Linux RAID Wiki doesn't cover mismatch_cnt at all.... would be kinda nice considering how critical (or not) this is... and what to do about it.



