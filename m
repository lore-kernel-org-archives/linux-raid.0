From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 15:59:47 -0700
Message-ID: <nrckp2$k8e$1@blaine.gmane.org>
References: <nramjg$n07$1@blaine.gmane.org>
 <20160914092959.GA3584@metamorpher.de> <nrc2pm$2a9$1@blaine.gmane.org>
 <20160914232249.6e5fc568@natsu> <nrce27$2km$1@blaine.gmane.org>
 <CAJCQCtQJwOTYsWubd0rV-6PRL4kmVRKLfLr3=7ZPr1Zb3SrwtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJCQCtQJwOTYsWubd0rV-6PRL4kmVRKLfLr3=7ZPr1Zb3SrwtQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Chris Murphy wrote on 09/14/2016 03:33 PM:
> SCT ERC value is less than SCSI command timer value?


they are 1TB Hitachi HUA7210SASUN drives in Sun Fire X4540 with SCT ERC 
value of 255 (25.5 seconds) and /sys/block/sdX/device/timeout is set to 30


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
