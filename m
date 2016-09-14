From: Chris Murphy <lists@colorremedies.com>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 17:15:03 -0600
Message-ID: <CAJCQCtQ1GHdQtShbW3U1o-fmXhT3fHrC7S9BxsxrrOG=0H_p3A@mail.gmail.com>
References: <nramjg$n07$1@blaine.gmane.org> <20160914092959.GA3584@metamorpher.de>
 <nrc2pm$2a9$1@blaine.gmane.org> <20160914232249.6e5fc568@natsu>
 <nrce27$2km$1@blaine.gmane.org> <CAJCQCtQJwOTYsWubd0rV-6PRL4kmVRKLfLr3=7ZPr1Zb3SrwtQ@mail.gmail.com>
 <nrckp2$k8e$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <nrckp2$k8e$1@blaine.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 14, 2016 at 4:59 PM, scar <scar@drigon.com> wrote:
> Chris Murphy wrote on 09/14/2016 03:33 PM:
>>
>> SCT ERC value is less than SCSI command timer value?
>
>
>
> they are 1TB Hitachi HUA7210SASUN drives in Sun Fire X4540 with SCT ERC
> value of 255 (25.5 seconds) and /sys/block/sdX/device/timeout is set to 30

Interesting choice, I haven't seen it cut that closely before, but it
ought to work. The value I most often see is 70 deciseconds which for
sure will fail, if it's going to, well before the command timer gives
up.


-- 
Chris Murphy
