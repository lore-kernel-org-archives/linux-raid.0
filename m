From: Luca Berra <bluca@comedia.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then
	disaster !!
Date: Sat, 30 Jan 2010 08:58:05 +0100
Message-ID: <20100130075805.GB15471@maude.comedia.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B633391.3020905@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B633391.3020905@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 08:14:25PM +0100, Giovanni Tessore wrote:
> To use a hot spare if available seems to me a very good idea.
> About the metedata version, I was quite disappointed to see that the 
> default when creating the array is still the 0.9 (correct me if newer 
> distros behave differently), which does not persist info about the 
> corrected read errors.
it was changed in mdadm 3.1.1

> Into a previous post I suggested to let at least the admins to be conscious 
> of the sistuation:
>
> I think it's also a mess for the image of the whole linux server community: 
> try to explain to a customer that his robust raid system, with 6 disks plus 
> 2 hot spares, just died because there were read errors, which were well 
> kwnown by the system; and that now all his valuable data are lost!!! That 
> customer may say "What a server...!!!", kill you, then get a win server by 
> sure!!

Oh, please, stop trolling.

L.
-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
