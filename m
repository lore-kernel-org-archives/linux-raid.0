From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 13:35:42 -0400
Message-ID: <51FBEDEE.1000801@redhat.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com> <51FAE985.1040809@redhat.com> <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com> <51FB63C8.2090300@hardwarefreak.com> <CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com> <51FBD2DC.3010900@redhat.com> <CAH3kUhELqOF3kruP1j94g3Yd4PwKL91rgUjoLDS=CTK5ieBuhg@mail.gmail.com> <51FBDFDF.70008@redhat.com> <CAH3kUhGepSynVH_bbSGfvtfVL5-84=jXhCZu7m90F7uP7GU=aw@mail.gmail.com> <51FBE34B.3000504@redhat.com> <CAH3kUhH840NmKbzOitQCZoPTfO3Oo+RqeCVvb3T_m3uRhKM1aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhH840NmKbzOitQCZoPTfO3Oo+RqeCVvb3T_m3uRhKM1aA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/2013 01:29 PM, Roberto Spadim wrote:
> nice, well, considering everything...
> 
> 1)partitions + raid1 is prefered for read speed and security
> 2)fileswap only if i can't add partitions
> 3)only use swap over single drive if don't have two devices (in this
> case use raid1)
> 4)there's no badblock layer in linux, each layer / filesystem must
> implement it by yourself
> 
> that's all right?

Yep.

