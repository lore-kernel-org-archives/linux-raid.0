From: greg@wind.enjellic.com (Dr. Greg Wettstein)
Subject: Re: Please help with a special RAID 1 setup
Date: Wed, 7 Jan 2004 09:32:43 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401071532.i07FWhK7003797@wind.enjellic.com>
References: <mirceac@interplus.ro>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Mircea Ciocan <mirceac@interplus.ro>
       "Please help with a special RAID 1 setup" (Jan  7, 12:16pm)
To: Mircea Ciocan <mirceac@interplus.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Jan 7, 12:16pm, Mircea Ciocan wrote:
} Subject: Please help with a special RAID 1 setup

>     Hello all,

Good morning to everyone on the list(s).

>     First excuse me for a looong message, but I've tryed to give as much 
> relevant details as possible.
> 
>     Please help me with this weird setup if it is possible and fesable:
> 
>     I have this raid1 device, composed of two fibre channel devices 
> mounted in RAID1, it works absolutely flawlessly.
> The resulted device is used for a lot of important data logging and the 
> ideea is to hotattach a 3-rd device ot the same size, wait for 
> syncronisation and after all of them are syncronised, stop the data 
> logging process, wait for a while, issue a sync command and hot detach 
> the 3-rd device restart de data logging and walk away with valid 
> filesytem backup of the main arry to be used as separate data analysys 
> source. I know that solution is somewhat cumberome but trust me this is 
> needed as is.

I know that it adds complexity but it would seem that this solution
would benefit from using LVM with its snap-shotting capabilities.

If you need to walk away with the data, snap the filesystem, copy the
snap to a separate device/filesystem, release the snap and you are
done.  I believe that there is a utility floating around that will
force synchronization of the filesystem (ext[23]) if your desire is to
have a coherent filesystem image as well.

I suspect that in the long run you will have a more coherent log image
with less muss and fuss.

>        Mircea Ciocan

Good luck with the project.

}-- End of excerpt from Mircea Ciocan

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Given a choice between a complex, difficult-to-understand,
disconcerting explanation and a simplistic, comforting one, many
prefer simplistic comfort if it's remotely plausible, especially if it
involves blaming someone else for their problems."
                                -- Bob Lewis
                                   _Infoworld_
