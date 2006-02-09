From: Luca Berra <luca.berra@comedia.it>
Subject: Re: Question: array locking, possible?
Date: Thu, 9 Feb 2006 21:48:48 +0100
Message-ID: <20060209204847.GA1387@percy.comedia.it>
References: <1C4766A743ADF74FAEDF2AAD0679BAA20767917E@cacexc03.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1C4766A743ADF74FAEDF2AAD0679BAA20767917E@cacexc03.americas.cpqcorp.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 09, 2006 at 10:28:58AM -0800, Stern, Rick (Serviceguard Linux) wrote:
>There is more interest, just not vocal.
>
>May want to look at LVM2 and its ability to use tagging to control enablement of VGs. This way it is not HW dependent.
>
I believe there is space in md1 superblock for a "cluster/exclusive"
flag, if not the name field could be used
what is missing is an interface between mdadm and cmcld so mdadm can ask
cmcld permission to activate an array with the "cluster/exclusive" flag
set.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
