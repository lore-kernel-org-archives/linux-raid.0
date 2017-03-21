From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 15:29:29 +0000
Message-ID: <58D146D9.5000301@youngman.org.uk>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <58D1244E.3040204@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D1244E.3040204@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/17 13:02, David Brown wrote:
> If you have to use two USB carriers for the whole process, try to make
> sure they are connected to separate root hubs so that they don't share
> the bandwidth.  This is not always just a matter of using two USB ports
> - sometimes two adjacent USB ports on a PC share an internal hub.

Having built a bunch of desktop pcs from parts, I'd say adjacent ports
almost certainly share an internal hub. Typically, a single mobo header
will run a wire to a double slot at the front, or a double slot at the
back. So plugging one in at the front, and one at the back, will get
round this unless it's actually just one hub in the ?northbridge.

Cheers,
Wol
