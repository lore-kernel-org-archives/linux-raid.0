From: Iustin Pop <iusty@k1024.org>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 2 Aug 2012 14:26:56 +0200
Message-ID: <20120802122656.GA25242@teal.hq.k1024.org>
References: <50191ADE.10809@fastmail.fm>
 <5019D052.4000409@hardwarefreak.com>
 <20120802091917.32fb0ca5@natsu>
 <501A316C.3020305@hardwarefreak.com>
 <20120802140634.6f729d07@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120802140634.6f729d07@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: stan@hardwarefreak.com, matt <listy@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 02, 2012 at 02:06:34PM +0600, Roman Mamedov wrote:
> I do not recommend using hardware RAID. It locks you into one card/vendor,
> usually is much less flexible than mdadm, and often even provides lower
> performance. See http://linux.yyz.us/why-software-raid.html

While that *can* be the case, I haven't ever seen md beating a HW RAID
adapter with battery-backed write-cache in certain metadata-intensive
workloads, so as usual it depends on what kind of HW raid you have, and
what performance you measure. Broad descriptions are not very helpful.

regards,
iustin
