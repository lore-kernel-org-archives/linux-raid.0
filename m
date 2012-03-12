From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Striping does not increase performance.
Date: Mon, 12 Mar 2012 16:23:21 +0000
Message-ID: <4F5E22F9.1040208@anonymous.org.uk>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com> <20120312125720.GL4558@voyageur.mas.nom.fr> <CAKFseUO5CVHBLhcY19DWzqhf-Ebrn7c-=iwxANuRcqwTV0PyBg@mail.gmail.com> <20120312135847.GM4558@voyageur.mas.nom.fr> <4F5E0963.6080708@cesnet.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F5E0963.6080708@cesnet.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: Erwan MAS <erwan@mas.nom.fr>, Caspar Smit <c.smit@truebit.nl>, linux-raid@vger.kernel.org, fio@vger.kernel.org
List-Id: linux-raid.ids

On 12/03/2012 14:34, Jiri Horky wrote:
> Hi,
>
> as for alignment, please also check md metadata format version (-e
> switch of mdadm). The version that ensures alignment is 1.0, which
> places the metadata information to the back of the drive.

As far as I can tell from looking at the source, ever since the 1.x 
metadata types were introduced (with mdadm 2.0, in August 2005):

* the data offset on 1.1 and 1.2 arrays has always been 4K-aligned,
* the superblock offset for 1.0 arrays has always been 4K-aligned,
* the bitmap offset for all 1.x arrays has always been 4K-aligned.

As of mdadm 3.1.2 (March 2010), the data offset for new 1.1 and 1.2 
arrays is always 1MB (2048 sectors), so they're also 1M-aligned.

Cheers,

John.

