From: Tim Small <tim@buttersideup.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25
 kernel
Date: Thu, 05 Aug 2004 10:20:53 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4111FBF5.8000806@buttersideup.com>
References: <ceq7ij$vj7$1@sea.gmane.org>	<27897.194.60.85.4.1091613610.squirrel@194.60.85.4>	<cesjcm$9da$1@sea.gmane.org> <87657ycaf9.fsf@enki.rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87657ycaf9.fsf@enki.rimspace.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Pittman wrote:

>>see subject (Debian). I've looked at SuSE though, it seems with their setup RAID and ReiserFS is much easier to handle. 
>>    
>>
>The upcoming release of Debian will feature MD and LVM device creation
>at install time, but is not yet stable; the current stable release does
>not support either of them.
>  
>
Sarge is pretty good at the moment (at least I am running production 
systems on it, and have been for the last few months) - the disadvantage 
of installing a new Woody system now is that security updates for it 
will probably stop before it's reached the end of it's useful life.  Of 
course, as it's Debian, you should be able to upgrade to Sarge 
relatively painlessly, but I'd probably rather avoid the hassle, and go 
straight to Sarge now.  I think Debian Installer currently includes 
support for installing Sarge directly onto md mirrors (including 
handling the boot-loader stuff), but I haven't tried it yet...  Might be 
worth trying one of the daily builds from:

http://www.debian.org/devel/debian-installer/

The disadvantage of installing Sarge yet is that it won't go through the 
official security updates until it is released, but in the mean time, 
you can pull security-fixes in from unstable (using apt-pinning if you 
like) - sounds nasty but it seems to work quite well in practice.  Sorry 
for getting distribution-centric on the list!

Tim.

