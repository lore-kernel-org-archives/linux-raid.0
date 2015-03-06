From: Phil Turmel <philip@turmel.org>
Subject: Re: raid 10 - Recovering raid - what stats are most helpfull?
Date: Fri, 06 Mar 2015 14:50:41 -0500
Message-ID: <54FA0511.3040002@turmel.org>
References: <493130695.186182.1425543528690.JavaMail.open-xchange@app10.ox.hosteurope.de> <54F85645.9000603@turmel.org> <270478433.23047.1425669790387.JavaMail.open-xchange@app04.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <270478433.23047.1425669790387.JavaMail.open-xchange@app04.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2015 02:23 PM, Stefan Lamby wrote:

> What information about the raid would you suggest to collect and to save
> somewhere to have it handy in case it is needed?

Most important is the complete "mdadm -E" output for every member
device.  With that you need a list that correlates the member device
names to the underlying drive serial numbers.  An *excerpt* from "ls -l
/dev/disk/by-id/" would suffice.  Or lsdrv output.  I wrote lsdrv to
generate a functional summary that includes all of the useful serial
numbers.

Regards,

Phil Turmel
-- 
200 Creekwood Trail
Fayetteville, GA 30214

Mobile: (404) 713-7284
Home:   (770) 719-0684
