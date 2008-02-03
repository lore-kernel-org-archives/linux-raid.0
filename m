From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid10 on three discs - few questions.
Date: Sun, 3 Feb 2008 17:48:42 -0600
Message-ID: <cccedfc60802031548y775f71c9gbcf08224c6747d22@mail.gmail.com>
References: <20080203235043.3dbb6433@szpak>
	 <18342.18975.229866.860765@notabene.brown>
	 <20080204002952.1241f801@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080204002952.1241f801@szpak>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Feb 3, 2008 5:29 PM, Janek Kozicki <janek_listy@wp.pl> wrote:
> Neil Brown said:     (by the date of Mon, 4 Feb 2008 10:11:27 +1100)
>
> wow, thanks for quick reply :)
>
> > > 3. Another thing - would raid10,far=2 work when three drives are used?
> > >    Would it increase the read performance?
> >
> > Yes.
>
> is far=2 the most I could do to squeeze every possible MB/sec
> performance in raid10 on three discs ?

In my opinion, yes. It has sequential read characteristics that place
at /or better than/ raid0. Writing is slower, about the speed of a
single disk, give or take.  The other two raid10 layouts (near and
offset) are very close in performance to each other - nearly identical
for reading/writing.

-- 
Jon
