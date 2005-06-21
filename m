From: Luca Berra <bluca@comedia.it>
Subject: Re: from raidtools2 to mdadm
Date: Tue, 21 Jun 2005 18:15:24 +0200
Message-ID: <20050621161524.GD27691@percy.comedia.it>
References: <42B7A866.1080802@tequila.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42B7A866.1080802@tequila.co.jp>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 21, 2005 at 02:40:54PM +0900, Clemens Schwaighofer wrote:
>Hi,
>
>as debian changed their package from raidtools2 to mdadm and left us
>users out in the cold (no mdadm.conf craeted, lsraid commands left in
>crontab, etc), I am now a bit worried if the command
>
>#> mdadm --detail --scan>> mdadm.conf
>
i use this script to convert from old raidtab to mdadm.con
http://cvs.mandriva.com/cgi-bin/cvsweb.cgi/SPECS/mdadm/raidtabtomdadm.sh



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
