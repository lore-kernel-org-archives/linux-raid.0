From: Luca Berra <bluca@comedia.it>
Subject: Re: Problem with auto-assembly on Itanium
Date: Wed, 9 Mar 2005 17:43:52 +0100
Message-ID: <20050309164352.GB21635@percy.comedia.it>
References: <1110364128.14707.19.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1110364128.14707.19.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 09, 2005 at 11:28:48AM +0100, Jimmy Hedman wrote:
>Is there any way i can make this work? Could it be doable with mdadm in
>a initrd?
>
mdassembled was devise for this purpose.

create an /etc/mdadm.conf with
echo "DEVICE partitions" >> /etc/mdadm.conf
/sbin/mdadm -D -b /dev/md0 | grep '^ARRAY' >> /etc/mdadm.conf

copy the mdadm.conf and mdassemble to initrd
make linuxrc run mdassemble.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
