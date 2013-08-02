From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 12:50:19 -0400
Message-ID: <51FBE34B.3000504@redhat.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com> <51FAE985.1040809@redhat.com> <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com> <51FB63C8.2090300@hardwarefreak.com> <CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com> <51FBD2DC.3010900@redhat.com> <CAH3kUhELqOF3kruP1j94g3Yd4PwKL91rgUjoLDS=CTK5ieBuhg@mail.gmail.com> <51FBDFDF.70008@redhat.com> <CAH3kUhGepSynVH_bbSGfvtfVL5-84=jXhCZu7m90F7uP7GU=aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhGepSynVH_bbSGfvtfVL5-84=jXhCZu7m90F7uP7GU=aw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/2013 12:40 PM, Roberto Spadim wrote:
> humm interesting, a last doubt, what error is reported to filesystem
> in this case today? badblock, read error, write error?
> 

Just an error on the request.  If it was a read request, it is a read
error.  If it was a write request, then it is a write error.
