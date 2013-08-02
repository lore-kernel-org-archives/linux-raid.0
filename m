From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 12:35:43 -0400
Message-ID: <51FBDFDF.70008@redhat.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com> <51FAE985.1040809@redhat.com> <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com> <51FB63C8.2090300@hardwarefreak.com> <CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com> <51FBD2DC.3010900@redhat.com> <CAH3kUhELqOF3kruP1j94g3Yd4PwKL91rgUjoLDS=CTK5ieBuhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhELqOF3kruP1j94g3Yd4PwKL91rgUjoLDS=CTK5ieBuhg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/2013 11:59 AM, Roberto Spadim wrote:
> nice good explanations thanks
> 
> one more doubt....
> filesystem handle bad blocks
> md handle bad blocks
> 
> what happen when i have a filesystem over md?
> does md report badblocks to filesystem?
> 

If md can not repair the block and it is unable to get the data from
some other device in the array, then and only then will it report the
error back up to the filesystem layer on top of it.  In that case, the
filesystem will see the error and execute whatever the default behavior
on error is, which is different from filesystem to filesystem, but in
the past has commonly been to force the filesystem immediately into a
read-only mode so no further damage can happen and attempts at repair
can be made in rescue mode.
