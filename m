From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 6 Apr 2009 21:33:25 +0200
Message-ID: <20090406193325.GA18829@maude.comedia.it>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 06, 2009 at 10:47:00AM -0400, Doug Ledford wrote:
> FWIW, I happen to disagree with this method.  And I'm currently testing out 
> a new algorithm for this in Fedora 11 beta.
>
> Does the array match an array mdadm.conf via uuid?  If yes, use name from 
> mdadm.conf.  If no, does the array match an entry in mdadm.conf via the 
> standard super-minor/name mapping?  If yes, and that array line contains a 
> uuid that doesn't match this entry, then use a random name because this is 
> likely a conflict.  If yes and that line does not contain a uuid entry, 
> then this is likely a match, but a poor one.  Use the name, but don't like 
> it.  If no, then this array didn't match the mdadm.conf file at all and is 
> likely a foreign array.  However, if there is no mdadm.conf file, or if 
> there is a mdadm.conf file and nothing in it used our name, then foreign or 
> not, it likely won't conflict on name, so go ahead and use the standard 
> name for this device.
i think the idea is sound,
i only took a glance at the implementation, but i cannot understand the
use of "conf_exists()" function...

Regards,
L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
