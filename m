From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Sun, 20 Jan 2008 21:19:13 -0600
Message-ID: <47940F31.7020907@pobox.com>
References: <4793AE0E.609@pobox.com> <20080120215734.GD17584@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080120215734.GD17584@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the tips, and in particular:

Iustin Pop wrote:

>   - if you download torrents, fragmentation is a real problem, so use a
>     filesystem that knows how to preallocate space (XFS and maybe ext4;
>     for XFS use xfs_io to set a bigger extend size for where you
>     download)

That's a very interesting idea; it also gives me an opportunity to 
experiment with XFS. I had been avoiding it because of possible 
power-failure issues on writes.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "She will have fun who knows when to work
   and when not to work."
    			-- Segami
