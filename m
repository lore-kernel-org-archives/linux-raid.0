From: Luca Berra <bluca@comedia.it>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 08:45:52 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040730064551.GA30508@percy.comedia.it>
References: <b476569a04072920533b757574@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b476569a04072920533b757574@mail.gmail.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 29, 2004 at 08:53:47PM -0700, Adam Hunt wrote:
>I'm looking at building what I guess you could call a budget NAS
>array.  I'm looking to start with four 250MB SATA drives on 3ware
>8506-4LP controller.  I eventually want to move to eight drives in the
>box.  Is there any reason to expect that the performance of eight
>drives spread across two 8506-4LP controllers is going to be any worse
>then the same eight drives all on one 8506-8?

maybe pci bus issues, but you don't tell us the intended layout.

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
