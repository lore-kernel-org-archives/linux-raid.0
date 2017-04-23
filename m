From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 14:45:14 +0200
Message-ID: <20170423124514.GA7049@metamorpher.de>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <645f80c8-9abe-e34e-91f0-950b9e852068@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <645f80c8-9abe-e34e-91f0-950b9e852068@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 23, 2017 at 02:32:07PM +0200, Patrik Dahlström wrote:
> Any thoughts?

What's the exact size of your drives?

blockdev --getsize64 /dev/sd[abcdefg]
