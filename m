From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: [PATCH V2] MD: add doc for raid5-cache
Date: Mon, 6 Feb 2017 21:02:32 +0000
Message-ID: <c2c87a20-05b5-f769-8eb6-4d7b164dfad6@youngman.org.uk>
References: <cac53388fd5903a006792c0165063d63eb66079d.1486408891.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cac53388fd5903a006792c0165063d63eb66079d.1486408891.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: philip@turmel.org, songliubraving@fb.com, neilb@suse.com, jure.erznoznik@gmail.com, rramesh2400@gmail.com
List-Id: linux-raid.ids



On 06/02/17 19:23, Shaohua Li wrote:
> I'm starting document of the raid5-cache feature. Please note this is a
> kernel doc instead of a mdadm manual, so I don't add the details about
> how to use the feature in mdadm side. Please let me know what else we
> should put into the document. Of course, comments are welcome!
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  Documentation/md/raid5-cache.txt | 109 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
>  create mode 100644 Documentation/md/raid5-cache.txt

Note that the kernel documentation is moving over to a new format - 
.rst. They're using a new system called Sphinx. There was an article on 
lwn about it. I've lost the reference to lwn, but if you look at 
https://www.kernel.org/doc/html/latest/ you will see that it is a match 
to Documentation/index.rst.

So of course, converting all the md stuff has made its way onto my "to 
do" list, but I don't want to start until I've got a converted kernel 
running on my system. I'm currently running 4.4.6 and I think it came 
out with something like 4.6. Problem is, running gentoo, my system is 
well out of date because I need a helper system to get me to upgrade and 
going from KDE4 to KDE5 is likely to give me grief :-)

You're probably working with an up-to-date kernel, but it's up to you - 
do you want to create a .rst file, or submit it as .txt and let me 
convert it and go through the grief of working out how to do it :-). 
Conversion is probably rather more than just converting the one file, 
it'll need converting the directory structure too, I expect. Any 
problems, Jon Corbet's probably our go-to guy.

Cheers,
Wol
