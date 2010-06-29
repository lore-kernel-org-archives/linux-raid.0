From: Shaochun Wang <scwang@ios.ac.cn>
Subject: Re: RAID5 write hole?
Date: Tue, 29 Jun 2010 14:16:35 +0800
Message-ID: <20100629061634.GA20532@localhost>
References: <20100626143125.GA1010@localhost>
 <4C27290D.6000609@xs4all.nl>
 <20100627221613.0c34c812@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100627221613.0c34c812@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 27, 2010 at 10:16:13PM +1000, Neil Brown wrote:
> On Sun, 27 Jun 2010 12:33:49 +0200
> John Hendrikx <hjohn@xs4all.nl> wrote:
> 
> parity blocks immediately.  If you have a write-intent-bitmap configured,
> this will be quite quick.  If not it could take hours.
How do I know whether my RAID5 has wirte-intent bitmap enabled?

-- 
Shaochun Wang <scwang@ios.ac.cn>

Jabber: fungusw@jabber.org
