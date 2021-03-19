import css from './index.module.css';

export default function Home() {
  return (
    <>
      <div className={css.bigXContainer}>
        <div className={css.bigX}>
          <div className={css.bigX1} />
          <div className={css.bigX2} />
        </div>
      </div>
      <div className={css.card}>
        <div className={`${css.title} ${css.cardRow}`}>xpm</div>
        <div className={`${css.cardRow}`}>
          Install the latest versions of any software on any platform.
        </div>
        <div className={css.term}>
          <pre>
            <Comment>Get xpm</Comment>
            <Command>curl -sSL xpm.sh/get | bash</Command>
            <Comment>Install without hassle</Comment>
            <Command>xpm install node go bazel google-chrome</Command>
          </pre>
        </div>
        <div className={css.cardRow}>
          <a href="https://github.com/bduffany/xpm">Check it out on GitHub</a>
        </div>
      </div>
    </>
  );
}

function Comment({ children }: Pick<JSX.IntrinsicElements['div'], 'children'>) {
  return (
    <span className={css.comment}>
      # {children}
      <br />
    </span>
  );
}

function Command({ children }: Pick<JSX.IntrinsicElements['div'], 'children'>) {
  return (
    <>
      <span className={css.ps1}>$ </span>
      {children}
      <br />
    </>
  );
}
