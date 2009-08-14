From: Luca Berra <bluca@comedia.it>
Subject: Re: -z not on RAID0 / MPIO hurdle
Date: Fri, 14 Aug 2009 17:35:21 +0200
Message-ID: <20090814153521.GA6501@maude.comedia.it>
References: <66781b10908121144n1f053b57led29391534614b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <66781b10908121144n1f053b57led29391534614b7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 12, 2009 at 07:44:10PM +0100, mark delfman wrote:
>DM MPIO works fine also, but not on the partitions, only the whole
>drive.  So when we MDadm DMx it overwrites the SdX2 partition etc.
run kpartx on the dm device, it should create mappings for the single
partitions.
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
