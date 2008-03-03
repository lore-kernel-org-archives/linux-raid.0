From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Strange RAID-5 rebuild problem
Date: Mon, 3 Mar 2008 13:38:55 +0100
Message-ID: <af0a426d91fbcc42e60a993f74bd038d@localhost>
References: <18379.18272.464486.925011@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18379.18272.464486.925011@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 3 Mar 2008 11:33:36 +1100, Neil Brown <neilb@suse.de> wrote:
> Yes.
> This bug is fixed by the following patch which I have just sent of for
> inclusion in mainline.
> The patches talks about "reshape" but it applies to "resync" too.
> 
> The workaround is to "mdadm -w" before the first write.

Thank you very much Neil.
I applied the patch on my system and now resyncing starts automatically if
you start writing to the RAID.


Kind regards,
Michael

