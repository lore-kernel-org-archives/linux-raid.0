From: Luca Berra <bluca@comedia.it>
Subject: Re: Partitioned raid and major number
Date: Sat, 28 Feb 2004 08:27:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040228072737.GC27430@percy.comedia.it>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au> <20040227165614.GO23988@traveler.cistron.net> <20040228010916.GC13404@drinkel.cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040228010916.GC13404@drinkel.cistron.nl>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 28, 2004 at 02:09:16AM +0100, Miquel van Smoorenburg wrote:
>Hmm. With a dynamic major, the system might fail at checking the root
>file system at boot. At that time, /dev is still read-only, and
>/dev/md/d0p1 might not be the correct device yet.
>
>So either mdp needs its own partition number, or we need a /dev/root
>device that's an alias for the current root (like /dev/console).
>
>Fortunately, that's very easy. Which makes me wonder why this hasn't
>been done before .. what am I overlooking ?
>
>Patch below uses 4,1 which is just arbitrary, ofcourse. Comments ?
>
I was missing this feature from linux, and i don't know why it was not
done before...
Having /dev/root also solves the similar problem of ppl whose root is on a
device-mapper like myself. (dm has dynamic majors)

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
