From: Roger Roglans <rroglans@gmail.com>
Subject: Re: Trouble reassembling RAID10
Date: Tue, 21 Feb 2017 14:24:54 -0600
Message-ID: <CAPXQET=rms55PMjGkDmJBuQ_qgW5pPzoANgz1XWFkqBeGj9UMg@mail.gmail.com>
References: <CAPXQET=6v3NTeujqtq69KfzAv1gpeG8vGQPfwMxxOaECvFR4sg@mail.gmail.com>
 <f01c3494-1191-fdf5-c32e-c60abcdc989e@turmel.org> <CAPXQETk=0j+2P-dex4GpPTmEyBpkUcqHt4WSKJnuNGZvuwY97g@mail.gmail.com>
 <58AC95F3.3010601@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58AC95F3.3010601@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey Wol,
Yes I followed it and it was immensely helpful. I guess I didn't want
to make my post too long so that is why I only included the shortened
command outputs; in the future I'll just include everything. I believe
that the big issue was that the --force command did not work when it
seemed like it should have. I will keep on the lookout for that bug
again in the future.

Just a note on the wiki: "When Things Go Wrogn" should be "When Things Go Wrong"

Best,
Roger

On Tue, Feb 21, 2017 at 1:33 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 21/02/17 18:38, Roger Roglans wrote:
>> Hi Phil,
>>
>> seems very useful to know in the future. I ended up just assuming
>> clean and using "--create". Since I was able to discern the exact
>> configurations, I was able to mount it and am currently transferring
>> data. I know it was not the ideal solution but I believe that it
>> worked out with only minimal corruption. I might have problems with
>> another array soon. If so, I will certainly contact this mailing list
>> again.
>
> If I can plug my own work :-) there is now a section on the linux wiki
> about troubleshooting an array, and what data to gather for the list.
> Look at
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>
> That should be enough to fix simple problems or, for more serious ones,
> you'll have the bulk if not all the information the members of the list
> will need, saving the back-and-forth of "can we have this, can we have
> that".
>
> If you find any problems with the information on the wiki, let me know
> and I'll endeavour to fix it.
>
> Cheers,
> Wol
