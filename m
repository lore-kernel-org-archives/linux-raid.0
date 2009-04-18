From: Luca Berra <bluca@comedia.it>
Subject: Re: prefered way to update mdadm/mdadm.conf
Date: Sat, 18 Apr 2009 10:18:38 +0200
Message-ID: <20090418081838.GC2124@maude.comedia.it>
References: <001b01c9bfa1$c5bd30c0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001b01c9bfa1$c5bd30c0$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 17, 2009 at 02:16:22PM -0700, Timothy D. Lenz wrote:
>There seems to be 2 ways to update mdadm.conf. One puts a little more info in and both create duplicate info that msut be removed.
>Which is the better way:
>
>mdadm --examine --scan >> /etc/mdadm/mdadm.conf
>mdadm --detail --scan >> /etc/mdadm/mdadm.conf

the former will check physical devices for md superblock, and read
information from the found sb.
the latter will query active array for information

I use mdadm -Esc partition | grep ARRAY >> /etc/mdadm/mdadm.conf
to inventory all array whether they are active or not.

I still would suggest checking the content of mdadm.conf after.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
