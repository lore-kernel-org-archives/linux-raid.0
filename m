From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: /proc/mdstat status documentation and md: export_rdev
Date: Thu, 28 Nov 2013 19:45:59 +0100
Message-ID: <52978F67.2050900@gmail.com>
References: <E90CEDA2-1AF7-4FCF-91F6-346D644CF674@gmail.com> <CB92E3E9-672C-456F-9767-719159BC0CE5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CB92E3E9-672C-456F-9767-719159BC0CE5@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/28/2013 06:11 PM, Ivan Lezhnjov IV wrote:
> I would appreciate it if someone pointed out if there is a documentation that can be used to interpret all the codes that appear in /proc/mdstat output. For example, I know that (F) means that an array member's status is Failed, but what about (S)? Are there any other status codes like that? What are their meanings?

Use the code Luke :-)

See drivers/md/md.c:md_seq_show(). This suggests:

(W) means write-mostly
(F) means faulty
(S) means spare

HH, Jan



